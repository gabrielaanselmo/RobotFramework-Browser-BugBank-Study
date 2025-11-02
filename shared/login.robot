*** Settings ***
Library    Browser

*** Variables ***
${BASE_URL}    https://bugbank.netlify.app/
${BROWSER}     chromium

*** Keywords ***
Abrir BugBank
    [Documentation]    Abre o navegador e navega para a página inicial do BugBank.
    New Browser    browser=${BROWSER}    headless=False
    New Page       url=${BASE_URL}
    Set Viewport Size    1920    1080
    
Fechar Browser
    [Documentation]    Fecha o navegador e encerra a sessão.
    Close Browser
