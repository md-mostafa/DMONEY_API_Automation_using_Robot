*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String


*** Variables ***
${base_url}             http://dmoney.roadtocareer.net
${req_url}              user/update

${json_file_path}       /home/akash/PycharmProjects/API_Automation_Using_Robot/Variables.json
${secret_key}           ROADTOSDET


*** Test Cases ***
TC_01: Update Information Of Customer 1
        #Creating Session
    create session    mysession     ${base_url}

        #Extracting the data from variables.json file
    ${json_obj}=         load json from file     ${json_file_path}
    ${token}=            get value from json     ${json_obj}     token
    ${customer_1_id}=    get value from json     ${json_obj}     $.customer_1_id

        # Creating the body of the request
    ${randomNumber}=    generate random string      8   [NUMBERS]
    ${nid}=             convert to string           613243${randomNumber}
    ${role}=            convert to string           Customer
    ${user_data}=       create dictionary    name=Mostafa     email=mostafa@gmail.com       password=TestPass        phone_number=01777777777    nid=${nid}  role=${role}

        #Converting Dictionary to JSON
    ${user_data_json}=      evaluate        json.dumps(${user_data},indent=3)
    log to console    ${user_data_json}

        #Creating Header
    ${headers}=      create dictionary    Content-Type=application/json    Authorization=${token[0]}     X-AUTH-SECRET-KEY=${secret_key}

        #Put Request
    ${response}=        put on session    mysession       ${req_url}/${customer_1_id[0]}     data=${user_data_json}    headers=${headers}
    log to console      ${response.json()}

        #Extracting data from response
    ${message}=             get value from json     ${response.json()}      message
    ${customer_1_phone}=    get value from json     ${response.json()}      user.phone_number

        # Saving the data to the variables.json file
    set to dictionary       ${json_obj}             customer_1_phone=${customer_1_phone[0]}
    dump json to file       ${json_file_path}       ${json_obj}

        #Validations
    should be equal as strings    ${response.status_code}       200
    should be equal as strings    ${message[0]}                 User updated successfully
