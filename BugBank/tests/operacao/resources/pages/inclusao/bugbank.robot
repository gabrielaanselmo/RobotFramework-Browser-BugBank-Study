*** Settings ***
Documentation    Testes para o fluxo de cadastro de novos usuários no BugBank
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
${BTN_FECHAR}               xpath=//a[text()='Fechar']
${ELEMENTO_TRANSFERENCIA}   id=btn-TRANSFERÊNCIA

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

And Eu Finalizo A Sessao
    [Documentation]    Encerra a sessão do navegador.
    Fechar Browser