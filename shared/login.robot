*** Settings ***
Library    Browser

*** Variables ***
${BASE_URL}    https://bugbank.netlify.app/
${BROWSER}     chromium

*** Keywords ***
Abrir BugBank
    [Documentation]    Abre o navegador e navega para a página inicial do BugBank.
    New Browser    browser=${BROWSER}    headless=True     
    New Page       url=${BASE_URL}
    
Fechar Browser
    [Documentation]    Fecha o navegador e encerra a sessão.
    Close Browser
