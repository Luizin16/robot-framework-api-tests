*** Settings ***
Documentation     Cadastro de produtos: regras de autenticação e autorização.
Resource          ../../resources/serverest.resource
Suite Setup       Preparar Usuarios
Suite Teardown    Limpar Usuarios

*** Variables ***
&{ADMIN}          _id=${EMPTY}
&{COMUM}          _id=${EMPTY}
${TOKEN_ADMIN}    ${EMPTY}
${TOKEN_COMUM}    ${EMPTY}

*** Test Cases ***
CT09 - Administrador deve cadastrar produto com sucesso
    ${produto}=    Gerar Produto
    ${resposta}=    Cadastrar Produto    ${produto}    ${TOKEN_ADMIN}
    Resposta Deve Ter Status E Mensagem    ${resposta}    201    Cadastro realizado com sucesso
    [Teardown]    Excluir Produto    ${resposta.json()}[_id]    ${TOKEN_ADMIN}

CT10 - Não deve cadastrar produto sem token
    ${produto}=    Gerar Produto
    ${resposta}=    Cadastrar Produto    ${produto}
    Resposta Deve Ter Status E Mensagem    ${resposta}    401
    ...    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

CT11 - Usuário comum não deve cadastrar produto
    ${produto}=    Gerar Produto
    ${resposta}=    Cadastrar Produto    ${produto}    ${TOKEN_COMUM}
    Resposta Deve Ter Status E Mensagem    ${resposta}    403    Rota exclusiva para administradores

*** Keywords ***
Preparar Usuarios
    Criar Sessao Na ServeRest
    ${admin}=    Cadastrar Usuario Valido    administrador=true
    ${comum}=    Cadastrar Usuario Valido    administrador=false
    ${token_admin}=    Obter Token    ${admin}
    ${token_comum}=    Obter Token    ${comum}
    Set Suite Variable    ${ADMIN}          ${admin}
    Set Suite Variable    ${COMUM}          ${comum}
    Set Suite Variable    ${TOKEN_ADMIN}    ${token_admin}
    Set Suite Variable    ${TOKEN_COMUM}    ${token_comum}

Limpar Usuarios
    Excluir Usuario    ${ADMIN}[_id]
    Excluir Usuario    ${COMUM}[_id]