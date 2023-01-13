*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String


*** Variables ***
${base_url}             http://dmoney.roadtocareer.net
${req_url}              /transaction/balance/SYSTEM

${json_file_path}       /home/akash/PycharmProjects/API_Automation_Using_Robot/Variables.json
${secret_key}           ROADTOSDET


*** Test Cases ***
TC: 1 Check System Balance
    create session    mysession     ${base_url}
        #Extracting the data from variables.json file
    ${json_obj}=        load json from file     ${json_file_path}
    ${token}=           get value from json     ${json_obj}     token

        #Creating Header
    ${header}=      create dictionary    Content-Type=application/json    Authorization=${token[0]}     X-AUTH-SECRET-KEY=${secret_key}

        #Get Request
    ${response}=       get on session    mysession     ${req_url}   headers=${header}
    log to console      ${response.json()}

        #Validations
    should be equal as strings    ${response.status_code}   200