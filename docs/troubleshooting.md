# 문제 해결

## Elasticsearch

### 기동 실패

**증상**: Elasticsearch 컨테이너가 시작되지 않거나 즉시 종료됨

**해결 방법**:
1. **메모리 부족**: `ES_JAVA_HEAP` 값을 줄이거나 호스트 메모리 확인
   ```bash
   # .env 파일에서 힙 크기 조정
   ES_JAVA_HEAP=512m
   ```

2. **권한 문제**: `ulimits` 설정 확인
   ```bash
   # 호스트에서 확인
   ulimit -n
   ulimit -l
   ```

3. **로그 확인**:
   ```bash
   docker compose logs elasticsearch
   ```

### 연결 실패

**증상**: Elasticsearch에 연결할 수 없음

**해결 방법**:
1. 컨테이너 상태 확인:
   ```bash
   docker compose ps elasticsearch
   ```

2. 포트 충돌 확인:
   ```bash
   netstat -tuln | grep 9200
   ```

3. 헬스 체크:
   ```bash
   curl http://localhost:9200
   ```

## MongoDB

### 연결 실패

**증상**: MongoDB에 연결할 수 없음

**해결 방법**:
1. **인증 정보 확인**: `.env` 파일의 사용자명/비밀번호 확인
   ```bash
   cat .env | grep MONGO
   ```

2. **포트 충돌**: 다른 MongoDB 인스턴스가 실행 중인지 확인
   ```bash
   netstat -tuln | grep 27017
   ```

3. **컨테이너 로그 확인**:
   ```bash
   docker compose logs mongodb
   ```

4. **수동 연결 테스트**:
   ```bash
   docker compose exec mongodb mongosh \
     --username ${MONGO_INITDB_ROOT_USERNAME} \
     --password ${MONGO_INITDB_ROOT_PASSWORD} \
     --authenticationDatabase admin
   ```

### 데이터 손실

**증상**: 데이터가 사라짐

**해결 방법**:
1. 볼륨 상태 확인:
   ```bash
   docker volume inspect mongo_data
   ```

2. 백업에서 복원 (백업이 있는 경우)

## DNS

### DNS 쿼리 실패

**증상**: 도메인 이름을 IP로 변환할 수 없음

**해결 방법**:
1. **CoreDNS 컨테이너 상태 확인**:
   ```bash
   docker compose ps coredns
   ```

2. **DNS 설정 확인**:
   ```bash
   docker compose exec coredns cat /Corefile
   ```

3. **존 파일 확인**:
   ```bash
   cat coredns/zones/redfin.dev.db
   ```

4. **네트워크 설정 확인**:
   ```bash
   docker network inspect redfin_net
   ```

5. **CoreDNS 재시작**:
   ```bash
   docker compose restart coredns
   ```

## Nginx

### 502 Bad Gateway

**증상**: Nginx가 백엔드 서비스에 연결할 수 없음

**해결 방법**:
1. 백엔드 서비스 상태 확인:
   ```bash
   docker compose ps
   ```

2. Nginx 로그 확인:
   ```bash
   tail -f nginx/logs/error.log
   ```

3. 네트워크 연결 확인:
   ```bash
   docker compose exec nginx ping [backend_service_name]
   ```

### SSL 인증서 오류

**증상**: HTTPS 연결 시 인증서 오류

**해결 방법**:
1. 인증서 파일 확인:
   ```bash
   ls -la nginx/certs/
   ```

2. 인증서 유효성 확인:
   ```bash
   openssl x509 -in nginx/certs/redfin.dev.pem -text -noout
   ```

3. Nginx 설정 확인:
   ```bash
   docker compose exec nginx nginx -t
   ```

## 일반적인 문제

### 포트 충돌

**증상**: 컨테이너가 시작되지 않음, "port already in use" 오류

**해결 방법**:
1. 사용 중인 포트 확인:
   ```bash
   netstat -tuln | grep [port_number]
   ```

2. 다른 프로세스 종료 또는 `docker-compose.yaml`에서 포트 변경

### 디스크 공간 부족

**증상**: 컨테이너가 시작되지 않거나 오류 발생

**해결 방법**:
1. 디스크 사용량 확인:
   ```bash
   df -h
   docker system df
   ```

2. 사용하지 않는 리소스 정리:
   ```bash
   docker system prune -a
   ```

3. 오래된 로그 파일 삭제

### 네트워크 문제

**증상**: 서비스 간 통신 불가

**해결 방법**:
1. 네트워크 상태 확인:
   ```bash
   docker network inspect redfin_net
   ```

2. 네트워크 재생성:
   ```bash
   docker compose down
   docker compose up -d
   ```

## 로그 수집

문제 해결을 위해 다음 명령어로 로그를 수집할 수 있습니다:

```bash
# 모든 서비스 로그 저장
docker compose logs > all_services.log 2>&1

# 특정 서비스 로그 저장
docker compose logs [service_name] > service.log 2>&1

# 최근 100줄만 저장
docker compose logs --tail=100 > recent.log 2>&1
```

## 추가 도움말

문제가 지속되면 다음을 확인하세요:

1. Docker 및 Docker Compose 버전 확인
2. 호스트 시스템 리소스 (CPU, 메모리, 디스크) 확인
3. 방화벽 설정 확인
4. GitHub Issues에 문제 보고

