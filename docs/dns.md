# DNS 설정

## CoreDNS 개요

CoreDNS는 내부 네트워크에서 `.redfin.dev` 도메인을 관리하는 DNS 서버입니다. 

### 주의사항

Windows Host Namespace(Docker Desktop VM)에 바인딩되어 있어 WSL2의 127.0.0.1:53에는 리스너가 없어 connection refuse가 발생할 수 있습니다. 컨테이너 포트 공개가 WSL 루프백이 아니라 Windows 호스트 쪽에 열려 있는 상태입니다.

## DNS 테스트

### DNS 서버 내부(WSL2)에서

```bash
dig +short dns.redfin.dev @127.0.0.1
dig +short api.redfin.dev @127.0.0.1
dig +short rag.redfin.dev @127.0.0.1
```

### 같은 서브넷의 다른 PC에서

```bash
dig +short rag.redfin.dev @192.168.0.123
dig -x 192.168.0.66 @192.168.0.123
```

## 네트워크 인프라 확인

네트워크 인프라 상태를 확인하려면:

```bash
chmod +x check_net_infra.sh
./check_net_infra.sh
```

## DNS 존 파일

DNS 설정은 `coredns/zones/` 디렉토리에 있는 존 파일로 관리됩니다:

- `redfin.dev.db`: 정방향 DNS 레코드 (도메인 → IP)
- `0.168.192.in-addr.arpa.db`: 역방향 DNS 레코드 (IP → 도메인)

## DNS 레코드 추가

새로운 서비스를 추가하거나 DNS 레코드를 변경하려면:

1. `coredns/zones/redfin.dev.db` 파일을 편집
2. CoreDNS 컨테이너 재시작:
   ```bash
   docker compose restart coredns
   ```

## 문제 해결

DNS 쿼리가 실패하는 경우:

1. CoreDNS 컨테이너 상태 확인:
   ```bash
   docker compose ps coredns
   ```

2. DNS 설정 확인:
   ```bash
   docker compose exec coredns cat /Corefile
   ```

3. 존 파일 확인:
   ```bash
   cat coredns/zones/redfin.dev.db
   ```

4. 네트워크 설정 확인:
   ```bash
   docker network inspect redfin_net
   ```

