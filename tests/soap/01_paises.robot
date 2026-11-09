*** Settings ***
Documentation    Testes de integração SOAP: envelope XML, SOAPAction e leitura da resposta.
Resource         ../../resources/paises_soap.resource
Suite Setup      Criar Sessao SOAP
Test Tags        soap    wip

*** Test Cases ***
CT13 - Deve retornar o nome do país pelo código ISO
    [Template]    Operacao Deve Retornar
    CountryName    BR    Brazil
    CountryName    JP    Japan
    CountryName    AR    Argentina

CT14 - Deve retornar a capital do país pelo código ISO
    [Template]    Operacao Deve Retornar
    CapitalCity    BR    Brasilia
    CapitalCity    JP    Tokyo
    CapitalCity    AR    Buenos Aires

CT15 - Código inexistente deve retornar mensagem de país não encontrado
    ${resposta}=    Chamar Operacao    CountryName    ZZ
    Resultado Da Operacao Deve Ser    ${resposta}    CountryName    Country not found in the database

*** Keywords ***
Operacao Deve Retornar
    [Arguments]    ${operacao}    ${codigo}    ${esperado}
    ${resposta}=    Chamar Operacao    ${operacao}    ${codigo}
    Resultado Da Operacao Deve Ser    ${resposta}    ${operacao}    ${esperado}