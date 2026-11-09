*** Settings ***
Documentation    Keywords do serviço SOAP CountryInfo (oorsprong.org).
Library          RequestsLibrary
Library          XML

*** Variables ***
${BASE_URL_SOAP}    https://webservices.oorsprong.org
${ENDPOINT}         /websamples.countryinfo/CountryInfoService.wso
${SESSAO_SOAP}      paises
${USER_AGENT}       Mozilla/5.0 (robot-framework-api-tests)
${ENVELOPE}         <?xml version="1.0" encoding="utf-8"?>
...                 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
...                 <soap:Body><{operacao} xmlns="http://www.oorsprong.org/websamples.countryinfo">
...                 <sCountryISOCode>{codigo}</sCountryISOCode>
...                 </{operacao}></soap:Body></soap:Envelope>
...                 separator=${SPACE}

*** Keywords ***
Criar Sessao SOAP
    Create Session    ${SESSAO_SOAP}    ${BASE_URL_SOAP}    verify=True

Chamar Operacao
    [Documentation]    Monta o envelope SOAP da operação (CountryName, CapitalCity) e envia.
    ...                O User-Agent próprio evita bloqueio do servidor ao cliente padrão do Python.
    [Arguments]    ${operacao}    ${codigo}
    ${corpo}=    Evaluate    $ENVELOPE.format(operacao=$operacao, codigo=$codigo)
    &{headers}=    Create Dictionary
    ...    Content-Type=text/xml; charset=utf-8
    ...    SOAPAction=""
    ...    User-Agent=${USER_AGENT}
    ${resposta}=    POST On Session    ${SESSAO_SOAP}    ${ENDPOINT}    data=${corpo.encode('utf-8')}
    ...    headers=${headers}    expected_status=anything
    RETURN    ${resposta}

Resultado Da Operacao Deve Ser
    [Documentation]    Lê o <OperacaoResult> do XML de resposta, ignorando os namespaces.
    [Arguments]    ${resposta}    ${operacao}    ${esperado}
    Status Should Be    200    ${resposta}
    ${xml}=    Parse Xml    ${resposta.text}    strip_namespaces=True
    ${resultado}=    Get Element Text    ${xml}    .//${operacao}Result
    Should Be Equal As Strings    ${resultado}    ${esperado}