#!/bin/bash

# ============================================================
# Instalador de Ambiente Web
# Cursos Técnicos de Desenvolvimento de Sistemas e Jogos Digitais
#
# Ambiente:
#   - HTML
#   - CSS
#   - JavaScript
#   - Git
#   - Visual Studio Code
#
# Compatibilidade:
#   Distribuições baseadas em Debian que utilizam APT/dpkg
#
# Versão: 1.1
# ============================================================

set -e


# ------------------------------------------------------------
# Cores
# ------------------------------------------------------------

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'


# ------------------------------------------------------------
# Variáveis
# ------------------------------------------------------------

ARCH=$(dpkg --print-architecture)

KEYRING="/usr/share/keyrings/microsoft.gpg"

VSCODE_SOURCES="/etc/apt/sources.list.d/vscode.sources"


# ------------------------------------------------------------
# Funções auxiliares
# ------------------------------------------------------------

pause() {
    echo
    read -p "Pressione ENTER para continuar..."
}

check_command() {
    command -v "$1" &> /dev/null
}

show_error() {
    echo
    echo -e "${RED}ERRO: $1${NC}"
    echo
}

show_success() {
    echo -e "${GREEN}$1${NC}"
}

show_warning() {
    echo -e "${YELLOW}$1${NC}"
}

show_title() {
    echo
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}========================================${NC}"
}


# ------------------------------------------------------------
# Verificar distribuição
# ------------------------------------------------------------

check_distribution() {

    if [[ ! -f /etc/os-release ]]; then
        show_error "Não foi possível identificar a distribuição Linux."
        exit 1
    fi

    source /etc/os-release

    if ! command -v apt &> /dev/null; then
        show_error "Este instalador requer uma distribuição baseada em Debian com APT."
        echo "Distribuição detectada: ${PRETTY_NAME:-desconhecida}"
        exit 1
    fi

    if ! command -v dpkg &> /dev/null; then
        show_error "O comando dpkg não foi encontrado."
        exit 1
    fi

    echo -e "${CYAN}Distribuição:${NC} ${PRETTY_NAME:-desconhecida}"
    echo -e "${CYAN}Arquitetura:${NC}   ${ARCH}"

    show_success "Sistema compatível."
}


# ------------------------------------------------------------
# Verificar arquitetura
# ------------------------------------------------------------

check_architecture() {

    case "$ARCH" in

        amd64|arm64|armhf)
            show_success "Arquitetura suportada."
            ;;

        *)
            show_error "Arquitetura não suportada: $ARCH"
            exit 1
            ;;

    esac
}


# ------------------------------------------------------------
# Verificar sudo
# ------------------------------------------------------------

check_sudo() {

    if ! command -v sudo &> /dev/null; then
        show_error "O comando sudo não está instalado."
        exit 1
    fi

    if ! sudo -v; then
        show_error "O usuário atual não possui permissão administrativa."
        exit 1
    fi
}


# ------------------------------------------------------------
# Verificar internet
# ------------------------------------------------------------

check_internet() {

    if ! command -v wget &> /dev/null; then
        return
    fi

    echo "Verificando conexão com a internet..."

    if ! wget -q --spider https://packages.microsoft.com; then
        show_error "Não foi possível acessar a internet."
        echo "Verifique a conexão de rede e tente novamente."
        exit 1
    fi

    show_success "Conexão com a internet OK."
}


# ------------------------------------------------------------
# Atualizar lista de pacotes
# ------------------------------------------------------------

update_system() {

    echo
    echo "Atualizando lista de pacotes..."

    sudo apt update

    show_success "Lista de pacotes atualizada."
}


# ------------------------------------------------------------
# Dependências internas
#
# Estas ferramentas não aparecem no menu.
# São utilizadas pelo próprio instalador.
# ------------------------------------------------------------

install_dependencies() {

    echo
    echo "Preparando ferramentas necessárias..."

    sudo apt install -y \
        curl \
        wget \
        gpg \
        unzip \
        zip \
        tree

    show_success "Dependências preparadas."
}


# ------------------------------------------------------------
# Instalar Git
# ------------------------------------------------------------

install_git() {

    show_title "Instalando Git"

    if check_command git; then

        show_warning "Git já está instalado."

        git --version

        return

    fi

    sudo apt install -y git

    echo
    show_success "Git instalado com sucesso!"

    git --version
}


# ------------------------------------------------------------
# Configurar repositório do VS Code
# ------------------------------------------------------------

setup_vscode_repository() {

    echo "Configurando repositório do VS Code..."

    sudo apt install -y wget gpg


    # --------------------------------------------------------
    # Chave Microsoft
    # --------------------------------------------------------

    if [[ ! -f "$KEYRING" ]]; then

        echo "Adicionando chave da Microsoft..."

        wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
            | sudo gpg --dearmor -o "$KEYRING"

        sudo chmod 644 "$KEYRING"

    fi


    # --------------------------------------------------------
    # Repositório VS Code
    # --------------------------------------------------------

    if [[ ! -f "$VSCODE_SOURCES" ]]; then

        sudo tee "$VSCODE_SOURCES" > /dev/null <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: $KEYRING
EOF

    fi

    show_success "Repositório do VS Code configurado."
}


# ------------------------------------------------------------
# Instalar VS Code
# ------------------------------------------------------------

install_vscode() {

    show_title "Instalando VS Code"

    if check_command code; then

        show_warning "VS Code já está instalado."

        code --version

        return

    fi

    setup_vscode_repository

    echo
    echo "Atualizando lista de pacotes..."

    sudo apt update

    echo
    echo "Instalando VS Code..."

    sudo apt install -y code

    echo
    show_success "VS Code instalado com sucesso!"

    code --version
}


# ------------------------------------------------------------
# Instalar extensões do VS Code
# ------------------------------------------------------------

install_vscode_extensions() {

    if ! check_command code; then
        show_warning "VS Code não está instalado."
        return
    fi

    echo
    echo "Configurando VS Code..."

    code --install-extension ritwickdey.LiveServer

    show_success "Extensões configuradas."
}


# ------------------------------------------------------------
# Instalar ambiente completo
# ------------------------------------------------------------

install_all() {

    show_title "Instalando ambiente completo"

    echo
    echo "Preparando o ambiente de desenvolvimento..."
    echo

    # Ferramentas utilizadas internamente pelo instalador
    install_dependencies

    # Ferramentas utilizadas pelos alunos
    install_git

    install_vscode

    # Configuração do VS Code
    install_vscode_extensions

    echo
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN} Ambiente instalado com sucesso!${NC}"
    echo -e "${GREEN}========================================${NC}"

    echo
    echo "O ambiente está pronto para:"
    echo
    echo "  HTML"
    echo "  CSS"
    echo "  JavaScript"
    echo "  Git"
    echo "  Visual Studio Code"
    echo
}


# ------------------------------------------------------------
# Verificar versões
# ------------------------------------------------------------

show_versions() {

    show_title "Ferramentas instaladas"

    echo

    if check_command git; then

        echo -e "${CYAN}Git:${NC}"
        git --version

    else

        echo -e "${YELLOW}Git: não instalado${NC}"

    fi

    echo

    if check_command code; then

        echo -e "${CYAN}VS Code:${NC}"
        code --version | head -n 1

    else

        echo -e "${YELLOW}VS Code: não instalado${NC}"

    fi

    echo
}


# ------------------------------------------------------------
# Menu principal
# ------------------------------------------------------------

show_menu() {

    clear

    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}       INSTALADOR - AMBIENTE WEB${NC}"
    echo -e "${BLUE}========================================${NC}"

    echo
    echo "Cursos Técnicos de Desenvolvimento de Sistemas e Jogos Digitais"
    echo
    echo -e "${CYAN}Desenvolvimento:${NC}"
    echo "  HTML + CSS + JavaScript"
    echo

    echo "1) Instalar Git"
    echo "2) Instalar VS Code"
    echo "3) Instalar ambiente completo"
    echo "4) Ver versões instaladas"
    echo "0) Sair"

    echo
}


# ------------------------------------------------------------
# Inicialização
# ------------------------------------------------------------

check_distribution
check_architecture
check_sudo

# Dependências mínimas para a verificação de internet
if ! check_command wget; then
    sudo apt update
    sudo apt install -y wget
fi

check_internet


# ------------------------------------------------------------
# Loop principal
# ------------------------------------------------------------

while true; do

    show_menu

    read -p "Digite uma opção: " option

    case "$option" in

        1)
            update_system
            install_dependencies
            install_git
            pause
            ;;

        2)
            update_system
            install_dependencies
            install_vscode
            install_vscode_extensions
            pause
            ;;

        3)
            update_system
            install_all
            pause
            ;;

        4)
            show_versions
            pause
            ;;

        0)
            echo
            echo "Saindo..."
            exit 0
            ;;

        *)
            echo
            show_error "Opção inválida!"
            pause
            ;;

    esac

done