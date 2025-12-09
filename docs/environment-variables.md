# 환경 변수

주요 환경 변수는 `.env` 파일에서 관리됩니다. `.env.example` 파일을 참고하여 필요한 환경 변수를 설정하세요.

## MongoDB

```bash
# MongoDB 관리자 계정
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=your_password

# 애플리케이션 계정
MONGO_APP_USERNAME=app_user
MONGO_APP_PASSWORD=app_password
MONGO_APP_DB=redfin_db

# MongoDB URI (선택사항)
MONGO_URI=mongodb://app_user:app_password@mongodb:27017/redfin_db

# 포트
MONGO_PORT=27017
```

## Elasticsearch

```bash
# Elasticsearch 버전
ELASTIC_VERSION=8.14.0

# 포트
ES_PORT=9200

# JVM 힙 메모리 크기 (호스트 메모리에 맞게 조정)
ES_JAVA_HEAP=1g
```

## Kibana

```bash
# Kibana 버전 (일반적으로 Elasticsearch 버전과 동일)
KIBANA_VERSION=8.14.0

# 포트
KIBANA_PORT=5601
```

## Qdrant

```bash
# HTTP API 포트
QDRANT_HTTP_PORT=6333

# gRPC 포트
QDRANT_GRPC_PORT=6334
```

## Mongo Express

```bash
# HTTP Basic Auth 활성화 여부
ME_CONFIG_BASICAUTH=true

# Basic Auth 사용자명
ME_CONFIG_BASICAUTH_USERNAME=admin

# Basic Auth 비밀번호
ME_CONFIG_BASICAUTH_PASSWORD=your_password
```

## 기타

```bash
# 타임존 설정
TZ=Asia/Seoul
```

## 환경 변수 설정 방법

### 1. .env 파일 생성

```bash
cp .env.example .env
```

### 2. .env 파일 편집

필요한 환경 변수를 설정합니다. 특히 다음 항목은 반드시 변경하세요:

- `MONGO_INITDB_ROOT_PASSWORD`: MongoDB 관리자 비밀번호
- `MONGO_APP_PASSWORD`: 애플리케이션 비밀번호
- `ME_CONFIG_BASICAUTH_PASSWORD`: Mongo Express 비밀번호

### 3. 환경 변수 적용

환경 변수를 변경한 후에는 해당 서비스를 재시작해야 합니다:

```bash
# 전체 스택 재시작
docker compose down
docker compose up -d

# 또는 특정 서비스만 재시작
docker compose restart [service_name]
```

## 보안 주의사항

⚠️ **중요**: 

- `.env` 파일은 Git 추적에서 제외됩니다
- 절대 `.env` 파일을 커밋하지 마세요
- 프로덕션 환경에서는 강력한 비밀번호를 사용하세요
- 비밀번호는 정기적으로 변경하세요
- 환경별로 다른 `.env` 파일을 사용하세요

## 환경 변수 확인

현재 설정된 환경 변수를 확인하려면:

```bash
# .env 파일 내용 확인
cat .env

# Docker Compose에서 사용 중인 환경 변수 확인
docker compose config
```

