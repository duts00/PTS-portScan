# postscan — Port scan simples para pentest

> **Sobre este projeto:** Este é um projeto educacional criado enquanto eu ainda estou estudando. Código experimental, destinado a aprendizado e testes em ambientes controlados. Se for usado em produção ou em redes de terceiros, proceda com cautela e obtenha autorização.

> Mini-ferramenta em Bash para identificar hosts com uma porta TCP aberta numa sub-rede.

## Objetivo

Descobrir quais hosts em uma rede possuem uma porta TCP específica (por exemplo, porta 80) aberta. O usuário informa a rede base (ex.: `172.16.1`) e a porta a ser verificada.

> Aviso: esta ferramenta é educacional e voltada para ambientes de teste (laboratórios, máquinas que você possui ou com permissão). O uso em redes de terceiros sem autorização é ilegal.

---

## Funcionalidades

* Varre hosts `x.x.x.1` a `x.x.x.254` da rede indicada.
* Usa `hping3` para enviar um único SYN (`-S`) e detectar respostas SYN/ACK (indicando porta aberta).
* Saída enxuta: mostra apenas os IPs que responderam com `flags=SA`.

---

## Requisitos

* Linux (ou WSL com compatibilidade de rede adequada)
* Bash
* `hping3` instalado (normalmente precisa ser executado como root para enviar pacotes raw)
* Permissão/autoridade para testar a rede alvo

No Debian/Ubuntu:

```bash
sudo apt update && sudo apt install -y hping3
```

---

## Uso

```bash
# sintaxe
./postScan.sh REDE PORTA

# exemplo
./postScan.sh 172.16.1 80
```

* `REDE`: a parte fixa do endereço (ex.: `172.16.1`) — o script itera `.1` até `.254`
* `PORTA`: número da porta TCP a ser testada (ex.: `80`)

### Exemplo de saída esperada

```
172.16.1.10
172.16.1.25
172.16.1.100
```

(ips que responderam com SYN/ACK)

---

## Observações técnicas e limites

1. **Permissões**: `hping3` envia pacotes raw — normalmente requer execução como `root`:

   ```bash
   sudo ./postScan.sh 172.16.1 80
   ```

2. **Ruído na rede**: muitos dispositivos e firewalls filtram ou bloqueiam pacotes SYN não esperados. Portanto, resultados podem variar.

4. **Confiabilidade**: o script faz apenas 1 tentativa (`-c 1`). Em redes instáveis, fazer múltiplas tentativas por IP aumenta confiabilidade.

5. **Compatibilidade**: o script assume endereços IPv4 e uma máscara /24. Para outras máscaras (ex.: /25, /22), adapte a lógica de iteração.

---

## Segurança & Legal

* Execute somente em redes que você possui ou tem autorização explícita para testar.
* Documente e obtenha a permissão por escrito quando fizer pentests em ambientes de terceiros.
* Use esta ferramenta para aprendizado e ambientes controlados.

---

## Como contribuir

1. Faça um fork do repositório.
2. Crie uma branch com sua mudança: `git checkout -b feat/parallel-scan`
3. Faça commits claros e teste as mudanças.
4. Abra um pull request descrevendo a melhoria.

---
