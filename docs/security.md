# 보안

## 인증서 관리

### SSL/TLS 인증서

- SSL/TLS 인증서는 `nginx/certs/` 디렉토리에 저장됩니다
- 인증서 파일(`*.pem`, `*.key`)은 `.gitignore`에 의해 Git 추적에서 제외됩니다
- 프로덕션 환경에서는 적절한 인증서를 배치해야 합니다

### 인증서 배치

개발 환경에서는 자체 서명 인증서를 사용할 수 있지만, 프로덕션 환경에서는 Let's Encrypt나 상용 CA에서 발급받은 인증서를 사용해야 합니다.

인증서 파일을 `nginx/certs/` 디렉토리에 배치한 후 Nginx를 재시작하세요:

```bash
docker compose restart nginx
```

## 환경 변수

### .env 파일 관리

- `.env` 파일은 Git 추적에서 제외됩니다
- `.env.example` 파일을 참고하여 필요한 환경 변수를 설정하세요
- 민감한 정보(비밀번호, API 키 등)는 절대 커밋하지 마세요

### 환경 변수 보안 모범 사례

1. **강력한 비밀번호 사용**: MongoDB, Elasticsearch 등의 기본 비밀번호를 반드시 변경하세요
2. **환경별 분리**: 개발, 스테이징, 프로덕션 환경별로 다른 `.env` 파일을 사용하세요
3. **비밀번호 관리**: 프로덕션 환경에서는 비밀번호 관리 도구(예: HashiCorp Vault, AWS Secrets Manager) 사용을 고려하세요
4. **정기적 로테이션**: 정기적으로 비밀번호와 인증서를 갱신하세요

## 네트워크 보안

### 방화벽 설정

프로덕션 환경에서는 필요한 포트만 외부에 노출하고, 나머지는 내부 네트워크에서만 접근 가능하도록 설정하세요.

### Nginx 보안 헤더

Nginx 설정에서 보안 헤더를 추가하여 XSS, 클릭재킹 등의 공격을 방지할 수 있습니다:

```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
```

## 컨테이너 보안

### 이미지 업데이트

정기적으로 Docker 이미지를 최신 버전으로 업데이트하여 보안 취약점을 패치하세요:

```bash
docker compose pull
docker compose up -d
```

### 최소 권한 원칙

컨테이너는 필요한 최소한의 권한만 가지도록 설정되어 있습니다. 추가 권한이 필요한 경우 신중하게 검토하세요.

