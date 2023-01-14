*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String


*** Variables ***
${base_url}             http://dmoney.roadtocareer.net
${req_url}              /user/delete

${json_file_path}       /home/akash/PycharmProjects/API_Automation_Using_Robot/Variables.json
${secret_key}           ROADTOSDET

*** Test Cases ***
TC_01: Delete Customer 1
        #Creating Session
    create session    mysession     ${base_url}

        #Extracting the data from variables.json file
    ${json_obj}=         load json from file     ${json_file_path}
    ${token}=            get value from json     ${json_obj}        $.token
    ${customer_1_id}=    get value from json     ${json_obj}        $.customer_1_id

        #Creating Header
    ${headers}=      create dictionary    Content-Type=application/json    Authorization=${token[0]}     X-AUTH-SECRET-KEY=${secret_key}

        #Delete request
    ${response}=        delete on session       mysession       ${req_url}/${customer_1_id[0]}     headers=${headers}
    log to console      ${response.json()}

        #Extracting data from response
    ${message}=             get value from json     ${response.json()}      message
    ${customer_1_id}=       get value from json     ${response.json()}      user.id

        #Validations
    should be equal as strings    ${response.status_code}       200
    should be equal as strings    ${message[0]}                 User deleted successfully
