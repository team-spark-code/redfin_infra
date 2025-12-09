# 설치 및 설정

## 사전 요구사항

- Docker Engine 20.10+
- Docker Compose v2.0+
- Bash 4.0+

## 설치 및 실행

### 1. 저장소 클론

```bash
git clone <repository-url>
cd redfin_infra
```

### 2. 환경 변수 설정

```bash
cp .env.example .env
# .env 파일을 편집하여 필요한 환경 변수를 설정하세요
```

자세한 환경 변수 설정은 [환경 변수 문서](./environment-variables.md)를 참고하세요.

### 3. 인프라 스택 시작

자동화 스크립트 사용:
```bash
chmod +x setup_stack.sh
./setup_stack.sh
```

또는 직접 Docker Compose 실행:
```bash
docker compose up -d
```

### 4. 서비스 상태 확인

```bash
docker compose ps
```

모든 서비스가 `Up` 상태인지 확인하세요.

## 디렉토리 구조

```
redfin_infra/
├── docker-compose.yaml      # 전체 인프라 스택 정의
├── setup_stack.sh           # 스택 초기화 및 시작 스크립트
├── check_net_infra.sh       # 네트워크 인프라 확인 스크립트
├── kibana_article_dashboard.sh  # Kibana 대시보드 설정 스크립트
├── nginx/                   # Nginx 설정
│   ├── nginx.conf          # 메인 Nginx 설정
│   ├── conf.d/             # HTTP/HTTPS 가상 호스트 설정
│   │   └── api-gateway.conf
│   ├── stream.d/           # TCP/UDP 스트림 프록시 설정
│   │   └── db-search.stream.conf
│   ├── certs/              # SSL/TLS 인증서 (Git 추적 제외)
│   └── logs/               # 액세스/에러 로그 (Git 추적 제외)
├── coredns/                # CoreDNS 설정
│   ├── Corefile            # DNS 서버 설정
│   └── zones/              # DNS 존 파일
│       ├── redfin.dev.db
│       └── 0.168.192.in-addr.arpa.db
├── docs/                   # 문서
└── README.md
```

## 초기 설정 확인

스택이 시작된 후 다음 명령어로 각 서비스가 정상 작동하는지 확인할 수 있습니다:

```bash
# Elasticsearch 확인
curl http://localhost:9200

# MongoDB 확인
docker compose exec mongodb mongosh --eval "db.adminCommand({ ping: 1 })"

# CoreDNS 확인
dig +short api.redfin.dev @127.0.0.1
```

