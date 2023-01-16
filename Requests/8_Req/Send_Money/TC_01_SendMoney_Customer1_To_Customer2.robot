*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String


*** Variables ***
${base_url}             http://dmoney.roadtocareer.net
${req_url}              /transaction/sendmoney

${json_file_path}       /home/akash/PycharmProjects/API_Automation_Using_Robot/Variables.json
${secret_key}           ROADTOSDET


*** Test Cases ***
TC_01: Send Money To Customer 2 From Customer 1
        #Creating Session
    create session    mysession     ${base_url}

        #Extracting the data from variables.json file
    ${json_obj}=            load json from file     ${json_file_path}
    ${token}=               get value from json     ${json_obj}     token
    ${customer_1_phone}=    get value from json     ${json_obj}     $.customer_1_phone
    ${customer_2_phone}=    get value from json     ${json_obj}     $.customer_2_phone
    ${customer_1_balance}=  get value from json     ${json_obj}     $.customer_1_balance
        #Creating Request Body
    ${amount}=      convert to integer      50
    ${user_data}=   create dictionary       from_account=${customer_1_phone[0]}     to_account=${customer_2_phone[0]}    amount=${amount}

        #Converting Dictionary to JSON
    ${user_data_json}=      evaluate        json.dumps(${user_data},indent=3)
    log to console    ${user_data_json}

        #Creating Header
    ${headers}=      create dictionary    Content-Type=application/json    Authorization=${token[0]}     X-AUTH-SECRET-KEY=${secret_key}

        #Post Request
    ${response}=        post on session    mysession       ${req_url}     data=${user_data_json}    headers=${headers}
    log to console      ${response.json()}

        #Extracting data from response
    ${message}=     get value from json    ${response.json()}       message
    ${balance}=     get value from json    ${response.json()}       currentBalance
    ${fee}=         get value from json    ${response.json()}       fee
    ${expectedBalance}=     evaluate    ${customer_1_balance[0]}-${fee[0]}-${amount}

        #Validations
    should be equal as strings    ${response.status_code}           201
    should be equal as strings    ${message[0]}                     Send money successful
    should be equal as integers   ${balance[0]}                     ${expectedBalance}

        # Saving the data to the variables.json file
    set to dictionary       ${json_obj}            customer_1_balance=${balance[0]}
    dump json to file       ${json_file_path}      ${json_obj}