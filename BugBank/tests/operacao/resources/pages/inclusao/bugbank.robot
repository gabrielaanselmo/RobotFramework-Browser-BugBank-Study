*** Settings ***
Documentation    Testes para os fluxos no BugBank
Resource         ../../../../../../shared/login.robot
Library          String
Library          FakerLibrary

*** Variables ***
# Selectors da Tela de Cadastro
${SALDO_INICIAL_TOGGLE}     True
${BTN_REGISTRAR}            css=#__next > div > div.pages__FormBackground-sc-1ee1f2s-2.jNpkvU > div > div.card__login > form > div.login__buttons > button.style__ContainerButton-sc-1wsixal-0.ihdmxA.button__child
${INPUT_EMAIL}              xpath=(//input[@placeholder='Informe seu e-mail'])[2]
${INPUT_NOME}               css=input[placeholder='Informe seu Nome']
${INPUT_SENHA}              xpath=(//input[@placeholder='Informe sua senha'])[2]
${INPUT_CONF_SENHA}         xpath=(//input[@placeholder='Informe a confirmação da senha'])[1]
${TOGGLE_SALDO}             id=toggleAddBalance
${BTN_CADASTRAR}            xpath=(//button[normalize-space()='Cadastrar'])[1]
${MSG_CADASTRO_SUCESSO}     id=modalText

# Selectors da Tela de Login
${FORM_LOGIN}               css=form[class='style__ContainerFormLogin-sc-1wbjw6k-0 eTrcYr']
${INPUT_LOGIN_EMAIL}        ${FORM_LOGIN} input[placeholder='Informe seu e-mail']
${INPUT_LOGIN_SENHA}        ${FORM_LOGIN} input[name='password']
${BTN_ACESSAR}              css=button[class='style__ContainerButton-sc-1wsixal-0 otUnI button__child']
${BTN_FECHAR}               css=#btnCloseModal

# Selectors da Tela de Transferência
${ELEMENTO_TRANSFERENCIA}   id=btn-TRANSFERÊNCIA
${INPUT_NUMERO_CONTA}       css=input[name='accountNumber']
${INPUT_DIGITO}             css=input[name='digit']
${INPUT_VALOR_TRANSF}       css=input[name='transferValue']
${INPUT_DESCRICAO}          css=input[name='description']
${BTN_TRANSFERIR}           xpath=//button[@type='submit']
${MSG_CONTA_INVALIDA}       id=modalText
${MSG_ESPERADA}             Conta inválida ou inexistente
${BTN_VOLTAR}               css=#btnBack

# Selectors da Tela Extrato
${BTN_EXTRATO}             id=btn-EXTRATO
${TEXT_SALDO_DISPONIVEL}   id=textBalanceAvailable
${SALDO_ESPERADO}          R$ 1.000,00

*** Keywords ***
Given Que Eu Abro A Pagina Inicial Do BugBank
    [Documentation]    Condição inicial para o teste BDD, usando a keyword do resource file.
    Abrir BugBank

When Eu Preencho O Cadastro Com Dados Padrao
    [Documentation]    Clica em Registrar e preenche o formulário usando as variáveis definidas.
    Click    ${BTN_REGISTRAR}
    Wait For Elements State    ${INPUT_EMAIL}    visible
    
    ${email_al} =    FakerLibrary.Email
    ${nome_al} =     FakerLibrary.Name
    ${senha_al} =    FakerLibrary.Password

    Set Test Variable    ${EMAIL_CRIADO}    ${email_al}
    Set Test Variable    ${SENHA_CRIADA}    ${senha_al}

    Fill Text    ${INPUT_EMAIL}         ${EMAIL_CRIADO}
    Fill Text    ${INPUT_NOME}          ${nome_al}
    Fill Text    ${INPUT_SENHA}         ${SENHA_CRIADA}
    Fill Text    ${INPUT_CONF_SENHA}    ${SENHA_CRIADA}
    
    IF    '${SALDO_INICIAL_TOGGLE}' == 'True'
        Click    ${TOGGLE_SALDO}
    END
    Click    ${BTN_CADASTRAR}

Then Devo Receber Uma Mensagem De Sucesso
    [Documentation]    Verifica a mensagem de sucesso dinâmica e fecha o modal.
    Wait For Elements State    ${MSG_CADASTRO_SUCESSO}    visible
    ${success_message}=    Get Text    ${MSG_CADASTRO_SUCESSO}
    Should Match Regexp    ${success_message}    ^A conta [0-9]{3}-[0-9] foi criada com sucesso$
    ${account_number}=    Get Regexp Matches    ${success_message}    ([0-9]{3}-[0-9])
    Log    Conta criada: ${account_number[0]}
    Click    ${BTN_FECHAR}

When Eu TENTO Logar Com A Conta Recem Criada
    [Documentation]    Preenche os campos de email e senha usando as variáveis promovidas.
    Fill Text    ${INPUT_LOGIN_EMAIL}    ${EMAIL_CRIADO}
    Wait For Elements State    ${INPUT_LOGIN_SENHA}    timeout=5s
    Fill Text    ${INPUT_LOGIN_SENHA}    ${SENHA_CRIADA}

And Eu Clico Em Acessar
    [Documentation]    Clica no botão de acesso para submeter as credenciais.
    Click    ${BTN_ACESSAR}

Then Devo Ser Redirecionado Para A Pagina Inicial
    [Documentation]    Verifica se a URL mudou para a página de saldo.
    Wait For Elements State  ${ELEMENTO_TRANSFERENCIA}  visible   timeout=10s
    ${current_url}=  Get Url
    Should Contain     ${current_url}     /home

When Eu TENTO Fazer Uma Transferencia Invalida
    [Documentation]  Clica no botão de Transferência e preenche campos com dados inválidos.
    Click     ${ELEMENTO_TRANSFERENCIA}

    Wait For Elements State    ${INPUT_NUMERO_CONTA}    visible     timeout=5s
    Fill Text     ${INPUT_NUMERO_CONTA}    9999
    Fill Text     ${INPUT_DIGITO}          0
    Fill Text     ${INPUT_VALOR_TRANSF}    23
    Fill Text     ${INPUT_DESCRICAO}       'Teste de Erro'
    
    Click         ${BTN_TRANSFERIR}

Then Devo Receber Uma Mensagem De Erro Conta inválida ou inexistente
    [Documentation]    Verifica a mensagem de erro esperada no modal de retorno.
    Wait For Elements State     ${MSG_CONTA_INVALIDA}    visible
    ${actual_message}=    Get Text    ${MSG_CONTA_INVALIDA}
    Should Be Equal      ${actual_message}  ${MSG_ESPERADA} 
    Click     ${BTN_FECHAR}

Then Eu Verifico O Saldo Disponivel
    [Documentation]    Clica no Extrato e verifica o saldo.
    Click     ${BTN_VOLTAR} 
    Click     ${BTN_EXTRATO}

    Wait For Elements State    ${TEXT_SALDO_DISPONIVEL}    visible

    ${saldo_com_nbsp}=    Get Text    ${TEXT_SALDO_DISPONIVEL}
    ${saldo_normalizado}=    String.Replace String    ${saldo_com_nbsp}    R$\xa0    R$ 
    ${saldo_formatado}=    String.Replace String    ${saldo_com_nbsp}    \xa0    ${SPACE}
    Should Be Equal    ${saldo_formatado}    ${SALDO_ESPERADO}
    Log     O saldo disponível verificado é: ${saldo_formatado}