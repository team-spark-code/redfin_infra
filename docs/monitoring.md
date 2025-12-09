# 모니터링 및 로그

## Kibana 대시보드

### 대시보드 설정

Article Recommender용 Kibana 대시보드를 자동으로 설정:

```bash
export KIBANA_URL=http://localhost:5601
chmod +x kibana_article_dashboard.sh
./kibana_article_dashboard.sh
```

설정이 완료되면 Kibana에서 대시보드를 확인할 수 있습니다:
- URL: `http://localhost:5601/app/dashboards#/view/dashboard-article-recommender`

### Kibana 접근

Kibana 웹 UI에 접근:
```bash
# 브라우저에서 열기
open http://localhost:5601
# 또는
xdg-open http://localhost:5601
```

## 로그 확인

### Nginx 로그

**액세스 로그:**
```bash
tail -f nginx/logs/access.log
```

**에러 로그:**
```bash
tail -f nginx/logs/error.log
```

### 컨테이너 로그

**특정 서비스 로그:**
```bash
docker compose logs -f [service_name]
```

**모든 서비스 로그:**
```bash
docker compose logs -f
```

**최근 로그만 확인:**
```bash
docker compose logs --tail=100 [service_name]
```

### 주요 서비스별 로그 확인

**Elasticsearch:**
```bash
docker compose logs -f elasticsearch
```

**MongoDB:**
```bash
docker compose logs -f mongodb
```

**Jenkins:**
```bash
docker compose logs -f jenkins
```

**CoreDNS:**
```bash
docker compose logs -f coredns
```

## 헬스 체크

### 서비스 상태 확인

```bash
docker compose ps
```

### 개별 서비스 헬스 체크

**Elasticsearch:**
```bash
curl http://localhost:9200/_cluster/health
```

**MongoDB:**
```bash
docker compose exec mongodb mongosh --eval "db.adminCommand({ ping: 1 })"
```

**Qdrant:**
```bash
curl http://localhost:6333/readyz
```

## 메트릭 수집

### Elasticsearch 메트릭

Elasticsearch는 기본적으로 메트릭을 제공합니다:

```bash
# 클러스터 상태
curl http://localhost:9200/_cluster/stats

# 노드 정보
curl http://localhost:9200/_nodes/stats
```

### 컨테이너 리소스 사용량

```bash
docker stats
```

특정 컨테이너만 확인:
```bash
docker stats redfin-nginx elasticsearch mongodb
```

