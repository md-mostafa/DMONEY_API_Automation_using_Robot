*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String


*** Variables ***
${base_url}             http://dmoney.roadtocareer.net
${req_url}              /transaction/deposit

${json_file_path}       /home/akash/PycharmProjects/API_Automation_Using_Robot/Variables.json
${secret_key}           ROADTOSDET

*** Test Cases ***
TC: 1 Successful Deposit To Agent
    create session  mysession       ${base_url}
            #Extracting the data from variables.json file
    ${json_obj}=        load json from file     ${json_file_path}
    ${token}=           get value from json     ${json_obj}     token
    ${agent_phone}=     get value from json     ${json_obj}     agent_phone

        #Creating Request Body
    ${amount}=      convert to integer      1000
    ${user_data}=   create dictionary       from_account=SYSTEM     to_account=${agent_phone[0]}    amount=${amount}
        #Converting Dictionary to JSON
    ${user_data_json}=      evaluate        json.dumps(${user_data},indent=3)
    log to console    ${user_data_json}

        #Creating Header
    ${header}=      create dictionary    Content-Type=application/json    Authorization=${token[0]}     X-AUTH-SECRET-KEY=${secret_key}

        #Post Request
    ${response}=     post on session    mysession       ${req_url}      data=${user_data_json}      headers=${header}
    log to console    ${response.json()}

        #Extracting data from response
    ${message}=     get value from json     ${response.json()}      message

        #Validation
    should be equal as strings      ${message[0]}               Deposit successful
    should be equal as strings      ${response.status_code}     201
