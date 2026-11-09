*** Settings ***
Documentation    Keywords da API ServeRest. Os detalhes de HTTP ficam aqui.
Library          RequestsLibrary
Library          ../libraries/DataFactory.py
Library          Collections
Library          ../libraries/SchemaValidator.py

*** Variables ***
${BASE_URL}      https://serverest.dev
${SESSAO}        serverest

*** Keywords ***
Criar Sessao Na ServeRest
    Create Session    ${SESSAO}    ${BASE_URL}    verify=True

Cadastrar Usuario
    [Arguments]    ${usuario}
    ${resposta}=    POST On Session    ${SESSAO}    /usuarios    json=${usuario}    expected_status=anything
    RETURN    ${resposta}

Resposta Deve Ter Status E Mensagem
    [Arguments]    ${resposta}    ${status}    ${mensagem}
    Status Should Be    ${status}    ${resposta}
    Should Be Equal As Strings    ${resposta.json()}[message]    ${mensagem}

Cadastrar Usuario Valido
    [Documentation]    Cria um usuário novo e devolve o usuário já com o _id gerado pela API.
    [Arguments]    ${administrador}=true
    ${usuario}=    Gerar Usuario    ${administrador}
    ${resposta}=    Cadastrar Usuario    ${usuario}
    Status Should Be    201    ${resposta}
    Set To Dictionary    ${usuario}    _id=${resposta.json()}[_id]
    RETURN    ${usuario}

Buscar Usuario
    [Arguments]    ${id}
    ${resposta}=    GET On Session    ${SESSAO}    /usuarios/${id}    expected_status=anything
    RETURN    ${resposta}

Excluir Usuario
    [Arguments]    ${id}
    ${resposta}=    DELETE On Session    ${SESSAO}    /usuarios/${id}    expected_status=anything
    RETURN    ${resposta}

Fazer Login
    [Arguments]    ${email}    ${password}
    &{credenciais}=    Create Dictionary    email=${email}    password=${password}
    ${resposta}=    POST On Session    ${SESSAO}    /login    json=${credenciais}    expected_status=anything
    RETURN    ${resposta}

Obter Token
    [Documentation]    Faz login e devolve o token "Bearer ..." pronto para usar no header.
    [Arguments]    ${usuario}
    ${resposta}=    Fazer Login    ${usuario}[email]    ${usuario}[password]
    Status Should Be    200    ${resposta}
    RETURN    ${resposta.json()}[authorization]

Cadastrar Produto
    [Arguments]    ${produto}    ${token}=${EMPTY}
    &{headers}=    Create Dictionary
    IF    $token    Set To Dictionary    ${headers}    Authorization=${token}
    ${resposta}=    POST On Session    ${SESSAO}    /produtos    json=${produto}    headers=${headers}
    ...    expected_status=anything
    RETURN    ${resposta}

Excluir Produto
    [Arguments]    ${id}    ${token}
    &{headers}=    Create Dictionary    Authorization=${token}
    DELETE On Session    ${SESSAO}    /produtos/${id}    headers=${headers}    expected_status=anything