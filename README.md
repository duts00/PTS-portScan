# portscan.sh — Varredura de Porta em Rede /24

Script Bash para identificar quais hosts de uma sub-rede possuem uma porta TCP aberta. O usuário informa a rede base e a porta; o script varre os endereços de `.1` a `.254` e lista os hosts que respondem com a porta aberta. Desenvolvido como exercício de estudo em reconhecimento de redes.

---

## Aviso Legal

Ferramenta educacional, voltada para laboratórios, máquinas próprias ou redes com autorização explícita. A varredura de portas em redes de terceiros sem permissão é ilegal (no Brasil, Lei 12.737/2012 e Marco Civil da Internet). Obtenha autorização por escrito antes de testar qualquer ambiente que não seja seu. Use de forma ética e responsável.

---

## Objetivo

Descobrir quais hosts de uma rede possuem uma porta TCP específica aberta (por exemplo, a porta 80). A técnica usada é o **SYN scan**: envia-se um pacote SYN para cada host e interpreta-se a resposta.

- Resposta `flags=SA` (SYN-ACK) → porta **aberta**
- Sem resposta ou outra flag → porta fechada/filtrada

---

## Funcionalidades

- Varre os hosts `.1` a `.254` da rede informada (máscara /24).
- Usa `hping3` com um pacote SYN por host (`-S -c 1`).
- Detecta portas abertas pela resposta SYN-ACK (`flags=SA`).
- Saída clara, indicando cada host com a porta aberta e um total ao final.
- Verifica previamente se está rodando como root e se o `hping3` está instalado.

---

## Requisitos

- Linux
- Bash
- `hping3` (envia pacotes SYN crus; requer execução como root)
- Permissão/autoridade para testar a rede alvo

Instalação em Debian/Ubuntu/Kali:

```bash
sudo apt update && sudo apt install -y hping3
```

---

## Uso

```bash
chmod +x portscan.sh
sudo ./portscan.sh REDE PORTA
```

- `REDE` — parte fixa do endereço (ex.: `172.16.1`); o script itera `.1` a `.254`
- `PORTA` — porta TCP a verificar (ex.: `80`)

### Exemplo

```bash
sudo ./portscan.sh 172.16.1 80
```

### Saída esperada

```
[*] Varrendo a rede 172.16.1.0/24 na porta 80 ...
---------------------------------------------
[+] 172.16.1.10   ->  porta 80 ABERTA
[+] 172.16.1.25   ->  porta 80 ABERTA
[+] 172.16.1.100  ->  porta 80 ABERTA
---------------------------------------------
[ok] Concluido. 3 host(s) com a porta 80 aberta.
```

---

## Observações Técnicas e Limites

1. **Permissões** — o `hping3` envia pacotes raw e exige root (`sudo`). O script verifica isso e avisa.
2. **Firewalls** — muitos dispositivos filtram ou descartam SYN inesperados; resultados podem variar.
3. **Confiabilidade** — o script envia 1 pacote por host (`-c 1`). Em redes instáveis, aumentar as tentativas melhora a precisão.
4. **Máscara /24** — assume IPv4 e /24. Para outras máscaras (/25, /22, etc.), a lógica de iteração precisa ser adaptada.
5. **Velocidade** — a varredura é sequencial; uma rede inteira leva algum tempo. Paralelizar aceleraria.

---

## Sugestões de Melhoria (exercícios)

- Receber faixa de portas, além de uma porta única
- Paralelizar a varredura para acelerar
- Múltiplas tentativas por host para maior confiabilidade
- Suporte a outras máscaras de rede
- Exportar o resultado para arquivo (TXT/CSV)

---

## Nota Final

Projeto de estudo em reconhecimento de redes e automação em Bash. O objetivo é compreender, na prática, como funciona um SYN scan e como hosts respondem a pacotes de sondagem — conhecimento que fundamenta tanto a fase de reconhecimento de um pentest quanto as defesas contra ela (firewalls, filtragem, detecção de varredura).

---

Desenvolvido por duts00 — projeto de estudo em segurança da informação
