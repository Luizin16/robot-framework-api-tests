*** Settings ***
Documentation     Autenticação na API ServeRest.
Resource          ../../resources/serverest.resource
Suite Setup       Preparar Usuario Para Login
Suite Teardown    Excluir Usuario    ${USUARIO}[_id]

*** Variables ***
&{USUARIO}        _id=${EMPTY}

*** Test Cases ***
CT06 - Login com credenciais válidas deve retornar token
    ${resposta}=    Fazer Login    ${USUARIO}[email]    ${USUARIO}[password]
    Resposta Deve Ter Status E Mensagem    ${resposta}    200    Login realizado com sucesso
    Should Start With    ${resposta.json()}[authorization]    Bearer
    Validar Contrato    ${resposta.json()}    login

CT07 - Login com senha inválida deve ser recusado
    ${resposta}=    Fazer Login    ${USUARIO}[email]    senha_errada
    Resposta Deve Ter Status E Mensagem    ${resposta}    401    Email e/ou senha inválidos

CT08 - Login com e-mail não cadastrado deve ser recusado
    ${resposta}=    Fazer Login    nao.existe.robot@teste.com    qualquer123
    Resposta Deve Ter Status E Mensagem    ${resposta}    401    Email e/ou senha inválidos

*** Keywords ***
Preparar Usuario Para Login
    Criar Sessao Na ServeRest
    ${usuario}=    Cadastrar Usuario Valido
    Set Suite Variable    ${USUARIO}    ${usuario}