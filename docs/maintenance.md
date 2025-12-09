# 유지보수

## 서비스 관리

### 서비스 재시작

특정 서비스만 재시작:
```bash
docker compose restart [service_name]
```

예시:
```bash
docker compose restart nginx
docker compose restart elasticsearch
```

### 서비스 중지

특정 서비스만 중지:
```bash
docker compose stop [service_name]
```

### 전체 스택 중지

모든 서비스를 중지하되 데이터 볼륨은 유지:
```bash
docker compose down
```

### 데이터 볼륨까지 완전 삭제

⚠️ **주의**: 이 명령어는 모든 데이터를 삭제합니다. 신중하게 사용하세요.

```bash
docker compose down -v
```

## 업데이트

### 이미지 업데이트

최신 이미지로 업데이트:
```bash
# 최신 이미지 다운로드
docker compose pull

# 서비스 재시작
docker compose up -d
```

### 설정 변경 후 재시작

설정 파일을 변경한 후 해당 서비스를 재시작:
```bash
docker compose up -d --force-recreate [service_name]
```

예시 (Nginx 설정 변경 후):
```bash
docker compose up -d --force-recreate nginx
```

## 백업

### MongoDB 백업

```bash
# 백업 생성
docker compose exec mongodb mongodump \
  --username ${MONGO_INITDB_ROOT_USERNAME} \
  --password ${MONGO_INITDB_ROOT_PASSWORD} \
  --authenticationDatabase admin \
  --out /data/backup

# 백업 복원
docker compose exec mongodb mongorestore \
  --username ${MONGO_INITDB_ROOT_USERNAME} \
  --password ${MONGO_INITDB_ROOT_PASSWORD} \
  --authenticationDatabase admin \
  /data/backup
```

### Elasticsearch 백업

Elasticsearch는 스냅샷 기능을 사용하여 백업할 수 있습니다. 자세한 내용은 [Elasticsearch 공식 문서](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots.html)를 참고하세요.

### 볼륨 백업

Docker 볼륨을 직접 백업:
```bash
# 볼륨 목록 확인
docker volume ls

# 볼륨 백업
docker run --rm \
  -v mongo_data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/mongo_data_backup.tar.gz -C /data .
```

## 로그 관리

### 로그 로테이션

Nginx 로그는 자동으로 로테이션되도록 설정되어 있습니다. 필요시 수동으로 로그를 정리할 수 있습니다:

```bash
# 오래된 로그 삭제
find nginx/logs -name "*.log.*" -mtime +30 -delete
```

### 로그 크기 제한

Docker Compose에서 로그 크기를 제한하려면 `docker-compose.yaml`에 다음 설정을 추가:

```yaml
services:
  nginx:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## 정기 점검

### 주간 점검 항목

- [ ] 모든 서비스가 정상 작동하는지 확인
- [ ] 디스크 사용량 확인
- [ ] 로그 파일 크기 확인
- [ ] 보안 업데이트 확인

### 월간 점검 항목

- [ ] Docker 이미지 업데이트
- [ ] 백업 상태 확인
- [ ] 인증서 만료일 확인
- [ ] 환경 변수 검토

