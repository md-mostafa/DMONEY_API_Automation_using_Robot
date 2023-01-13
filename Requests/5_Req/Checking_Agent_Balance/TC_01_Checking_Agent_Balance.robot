*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String


*** Variables ***
${base_url}             http://dmoney.roadtocareer.net
${req_url}              /transaction/balance

${json_file_path}       /home/akash/PycharmProjects/API_Automation_Using_Robot/Variables.json
${secret_key}           ROADTOSDET


*** Test Cases ***
TC: 1 Check Agent Balance
        #Creating Session
    create session    mysession     ${base_url}

        #Extracting the data from variables.json file
    ${json_obj}=        load json from file     ${json_file_path}
    ${token}=           get value from json     ${json_obj}     token
    ${agent_phone}=     get value from json     ${json_obj}     agent_phone

        #Creating Header
    ${headers}=      create dictionary    Content-Type=application/json    Authorization=${token[0]}     X-AUTH-SECRET-KEY=${secret_key}

        #Get Request
    ${response}=       get on session    mysession     ${req_url}/${agent_phone[0]}   headers=${headers}
    log to console      ${response.json()}

        #Extracting data from response
    ${message}=         get value from json     ${response.json()}      message
    ${agent_balance}=   get value from json     ${response.json()}      balance

        #Savging data to the variable.json
    set to dictionary   ${json_obj}     agent_balance=${agent_balance[0]}
    dump json to file   ${json_file_path}       ${json_obj}

        #Validations
    should be equal as strings    ${response.status_code}   200
    should be equal as strings    ${message[0]}     User balance