*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String


*** Variables ***
${base_url}             http://dmoney.roadtocareer.net
${req_url}              /user/create
${json_file_path}       /home/akash/PycharmProjects/API_Automation_Using_Robot/Variables.json
${secret_key}           ROADTOSDET

*** Test Cases ***
TC1: Creation Of User 2
    create session    mysession     ${base_url}

        # Creating the body of the request
    ${randomNumber}=    generate random string      8   [NUMBERS]
    ${randomName}=      generate random string      8-15
    ${randomEmail}=     convert to string           EmailTest${randomName}@gmail.com
    ${password}=        convert to string           TestPassword${randomName}
    ${phoneNumber}=     convert to string           015${randomNumber}
    ${nid}=             convert to string           613243${randomNumber}
    ${role}=            convert to string           Agent

    ${user_data}=       create dictionary   name=${randomName}    email=${randomEmail}    password=${password}    phone_number=${phoneNumber}     nid=${nid}    role=${role}
        # Converting the dictionary in json
    ${user_data_json}=  evaluate    json.dumps(${user_data},indent=3)
    log to console    ${user_data_json}

        #Extracting the token from variables.json file
    ${json_obj}=    load json from file     ${json_file_path}
    ${token}=       get value from json     ${json_obj}     token

        #Creating Headers
    ${header}=      create dictionary    Content-Type=application/json      Authorization=${token[0]}       X-AUTH-SECRET-KEY=${secret_key}
        #Post Request
    ${response}=       POST On Session    mysession     /user/create        data=${user_data_json}       headers=${header}
    log to console      ${response.content}


        #Extracting data from response
    ${message}=             get value from json     ${response.json()}      message
    ${agent_id}=            get value from json     ${response.json()}      user.id
    ${agent_phone}=         get value from json     ${response.json()}      user.phone_number
        # Saving the data to the variables.json file
    set to dictionary       ${json_obj}             agent_id=${agent_id[0]}
    set to dictionary       ${json_obj}             agent_phone=${agent_phone[0]}
    dump json to file       ${json_file_path}       ${json_obj}

        #Validations
    should be equal     ${message[0]}       User created successfully
    should be equal as strings      ${response.status_code}     201


