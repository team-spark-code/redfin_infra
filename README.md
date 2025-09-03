### CoreDNS 설정
- Windows Host Namespace(Docker Desktop VM) 측에 바인딩되어, 
  WSL2의 127.0.0.1:53에는 리스너가 없어 connection refuse 발생
- 컨테이너 포트 공개가 WSL 루프백이 아니라 Windows 호스트 쪽에 열려 있는 상태

### CoreDNS 테스트
```bash
# DNS 서버 내부(WSL2)
dig +short dns.redfin.dev @127.0.0.1
dig +short api.redfin.dev @127.0.0.1
dig +short rag.redfin.dev @127.0.0.1

# 같은 서브넷의 다른 PC
dig +short rag.redfin.dev @192.168.0.123
dig -x 192.168.0.66 @192.168.0.123
```
