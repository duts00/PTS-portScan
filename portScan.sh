#Objetivo:

#Criar um script para descobrir quais hosts na rede possuem uma determinada porta aberta. 

#o usuário deve informar a rede e o script deve retornar os hosts que possuem a porta 80 aberta. 

#!bin/bash

if [ "$1" == "" ]; # se usuario nao escrever nada o programa mostra como usar.

then
    echo "DUTS00 SECURITY - PORTSCAN NETWORK "
    echo "modo de uso: $0 REDE | PORTA "
    echo "exemplo: $0 172.16.1 | 80"
else
# se nao ele sera executado ação !
for ip in {1..254};
do
hping3 -S -p $2 -c 1 $1.$ip; 2> /dev/null | grep "flags=SA" | cut -d " " -f 2 | cut -d "=" -f 2;
done
fi
