*** Settings ***
Documentation    Testes de usuários da API ServeRest.
Resource         ../../resources/serverest.resource
Suite Setup      Criar Sessao Na ServeRest

*** Test Cases ***
CT01 - Cadastrar usuário com sucesso
    ${usuario}=    Gerar Usuario
    ${resposta}=    Cadastrar Usuario    ${usuario}
    Resposta Deve Ter Status E Mensagem    ${resposta}    201    Cadastro realizado com sucesso
    Should Not Be Empty    ${resposta.json()}[_id]
    [Teardown]    Excluir Usuario    ${resposta.json()}[_id]

CT02 - Usuário cadastrado deve ser salvo com os dados enviados
    ${usuario}=    Cadastrar Usuario Valido
    ${resposta}=    Buscar Usuario    ${usuario}[_id]
    Status Should Be    200    ${resposta}
    Should Be Equal    ${resposta.json()}[nome]     ${usuario}[nome]
    Should Be Equal    ${resposta.json()}[email]    ${usuario}[email]
    [Teardown]    Excluir Usuario    ${usuario}[_id]

CT03 - Não deve cadastrar usuário com e-mail já utilizado
    ${usuario}=    Gerar Usuario
    ${primeiro}=    Cadastrar Usuario    ${usuario}
    Status Should Be    201    ${primeiro}
    ${resposta}=    Cadastrar Usuario    ${usuario}
    Resposta Deve Ter Status E Mensagem    ${resposta}    400    Este email já está sendo usado
    [Teardown]    Excluir Usuario    ${primeiro.json()}[_id]

CT04 - Não deve cadastrar usuário sem nome
    ${usuario}=    Gerar Usuario
    Set To Dictionary    ${usuario}    nome=${EMPTY}
    ${resposta}=    Cadastrar Usuario    ${usuario}
    Status Should Be    400    ${resposta}
    Should Be Equal As Strings    ${resposta.json()}[nome]    nome não pode ficar em branco

CT05 - Excluir usuário com sucesso
    ${usuario}=    Cadastrar Usuario Valido
    ${resposta}=    Excluir Usuario    ${usuario}[_id]
    Resposta Deve Ter Status E Mensagem    ${resposta}    200    Registro excluído com sucesso
    ${busca}=    Buscar Usuario    ${usuario}[_id]
    Resposta Deve Ter Status E Mensagem    ${busca}    400    Usuário não encontrado

CT06 - Resposta de usuário deve respeitar o contrato
    ${usuario}=    Cadastrar Usuario Valido
    ${resposta}=    Buscar Usuario    ${usuario}[_id]
    Validar Contrato    ${resposta.json()}    usuario
    [Teardown]    Excluir Usuario    ${usuario}[_id]