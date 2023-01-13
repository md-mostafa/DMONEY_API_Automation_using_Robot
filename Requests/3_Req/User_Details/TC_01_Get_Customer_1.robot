*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String


*** Variables ***
${base_url}             http://dmoney.roadtocareer.net
${req_url}              user/search?

${json_file_path}       /home/akash/PycharmProjects/API_Automation_Using_Robot/Variables.json
${secret_key}           ROADTOSDET

*** Test Cases ***
TC1: Get Customer 1 Details
    create session    mysession     ${base_url}
        #Extracting the data from variables.json file
    ${json_obj}=    load json from file     ${json_file_path}
    ${token}=       get value from json     ${json_obj}     token
    ${id}=          get value from json     ${json_obj}     customer_1_id

        #Creating Headers
    ${header}=      create dictionary    Content-Type=application/json      Authorization=${token[0]}       X-AUTH-SECRET-KEY=${secret_key}

        #Get Request
    ${param}=       create dictionary       id=${id[0]}
    ${response}=       get on session    mysession     ${req_url}   params=${param}      headers=${header}
    log to console      ${response.json()}


        #Extracting data from response
    ${customer_1_id}=       get value from json     ${response.json()}      user.id
    ${customer_1_phone}=    get value from json     ${response.json()}      user.phone_number

        #Validations
    should be equal as strings    ${response.status_code}   200
    should be equal as strings      ${customer_1_id[0]}     ${id[0]}


