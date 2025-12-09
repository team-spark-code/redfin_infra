#!/bin/bash
set -euo pipefail

# 1) .env 없으면 생성
if [ ! -f .env ]; then
  cat > .env <<'EOF'
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=Redfin7620!
MONGO_PORT=27017
ELASTIC_VERSION=8.14.0
ES_PORT=9200
ES_JAVA_HEAP=1g
EOF
  echo "[init] .env 생성"
fi

# 2) .env 파일 로드
set -a  # 자동으로 export
source .env
set +a

# 3) 데이터 볼륨은 compose에서 자동 생성됨. 바로 up
docker compose up -d

echo "[wait] MongoDB/Elasticsearch 기동 대기..."
# 4) 간단 헬스체크
tries=30
until curl -fsS "http://localhost:${ES_PORT:-9200}" >/dev/null 2>&1; do
  ((tries--)) || { echo "Elasticsearch 기동 실패"; exit 1; }
  sleep 2
done

# MongoDB ping
docker compose exec -T mongodb mongosh \
  --username "${MONGO_INITDB_ROOT_USERNAME:-admin}" \
  --password "${MONGO_INITDB_ROOT_PASSWORD:-Redfin7620!}" \
  --authenticationDatabase admin \
  --eval 'db.adminCommand({ ping: 1 })' >/dev/null

echo "[ok] Elasticsearch: http://localhost:${ES_PORT:-9200}"
echo "[ok] MongoDB: mongodb://$MONGO_INITDB_ROOT_USERNAME:***@localhost:${MONGO_PORT:-27017}"
# echo "[ok] Mongo Express(UI): http://localhost:8081  # (옵션 서비스 활성화 시)"
