# Instalador de Ambiente para Programação

Instalador utilizado para preparar as máquinas do **Cursos Técnicos de Desenvolvimento de Sistemas e Jogos Digitais**.

O ambiente é voltado inicialmente para:

- HTML
- CSS
- JavaScript
- Git
- Visual Studio Code

O instalador foi desenvolvido para distribuições Linux baseadas em Debian que utilizam `apt` e `dpkg`, como Ubuntu, Linux Mint e Debian.

-----

## 🚀 Instalação

### 1. Baixe o instalador

Acesse o repositório do projeto e baixe o arquivo:
```bash
lab-config.sh
```

No GitHub, você pode fazer isso clicando no arquivo e depois no icone de **Download raw file(📥)**

> Se o professor disponibilizar o arquivo `lab-config.sh` diretamente, você também pode utilizá-lo sem baixar o repositório completo.

### 2. Abra o terminal na pasta do instalador

Entre no diretório onde o arquivo `lab-config.sh` foi salvo.

Por exemplo:
```bash
cd ~/Downloads
```

Você pode verificar se o arquivo está na pasta utilizando:
```bash
ls
```

Procure pelo arquivo:
```bash
lab-config.sh
```

### 3. Dê permissão de execução

Antes de executar o instalador, precisamos informar ao Linux que o arquivo pode ser executado:
```bash
chmod +x lab-config.sh
```

### 4. Execute o instalador

Agora execute:
```bash
./lab-config.sh
```

O instalador apresentará um menu com as opções disponíveis.

Para preparar uma máquina nova, escolha:
```
3) Instalar ambiente completo
```

Durante a instalação, o Linux poderá solicitar sua senha. Isso é normal, pois alguns programas precisam ser instalados com permissões administrativas.

### 5. Depois da instalação

Quando o ambiente estiver instalado, você terá acesso às principais ferramentas utilizadas no início do curso:

- Git
- Visual Studio Code
- Live Server
- ferramentas auxiliares necessárias ao ambiente

-----

## 📋 Menu

Ao executar o instalador, você verá:
```
1) Instalar Git
2) Instalar VS Code
3) Instalar ambiente completo
4) Ver versões instaladas
0) Sair
```
### 1 — Instalar Git

Instala o **Git**, utilizado para controle de versão dos projetos.

### 2 — Instalar VS Code

Instala o **Visual Studio Code**, que será utilizado como editor durante as aulas.

A extensão **Live Server** também será configurada automaticamente.

### 3 — Instalar ambiente completo

É a opção recomendada para preparar uma máquina nova.

Ela instala e configura:

- Git
- Visual Studio Code
- Live Server
- ferramentas auxiliares necessárias ao funcionamento do instalador

As ferramentas auxiliares são instaladas automaticamente e não precisam ser configuradas pelo aluno.

### 4 — Ver versões instaladas

Mostra as versões do Git e do VS Code instaladas na máquina.

### 0 — Sair

Fecha o instalador.

---

💻 Requisitos

O computador precisa:

- utilizar uma distribuição baseada em Debian;
- possuir `apt` e `dpkg`;
- possuir conexão com a internet;
- possuir um usuário com permissão para utilizar `sudo`.

Para verificar a distribuição:
```bash
cat /etc/os-release
```

Para verificar a arquitetura:
```bash
dpkg --print-architecture
```
-----

## ⚠️ Problemas comuns
### Permission denied

Execute:
```bash
chmod +x lab-config.sh
```

Depois:
```bash
./lab-config.sh
```
---

## 🎯 Objetivo

A proposta deste projeto é deixar as máquinas prontas para as primeiras atividades de desenvolvimento web, mantendo o ambiente simples e adequado para computadores com recursos limitados.

Novas ferramentas poderão ser adicionadas ao instalador conforme a necessidade do curso.
