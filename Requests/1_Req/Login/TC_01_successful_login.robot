*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os

*** Variables ***
${base_url}             http://dmoney.roadtocareer.net
${req_url}              /user/login
${json_file_path}       /home/akash/PycharmProjects/API_Automation_Using_Robot/Variables.json


*** Test Cases ***
TC1: Successful Login With Valid Credentials
        create session      login       ${base_url}

            #Creating headers, body
        ${header}=      create dictionary       Content-Type=application/json
        ${body}=        create dictionary       email=salman@roadtocareer.net   password=1234
        ${response}=    POST On Session     login     ${req_url}    json=${body}    headers=${header}

        log to console      \nResponse: \n${response.content}

            #Extracting Values From Response
        ${message}=     get value from json     ${response.json()}      message
        ${token}=       get value from json    ${response.json()}       token
        #log to console    \nMessage :\n${message[0]}

            #Saving the token to the json file
        ${json_obj}=        load json from file     ${json_file_path}
        set to dictionary   ${json_obj}     token=${token[0]}
        dump json to file   ${json_file_path}       ${json_obj}

            #Validation
        should be equal             ${message[0]}               Login successfully
        should be equal as strings  ${response.status_code}     200

