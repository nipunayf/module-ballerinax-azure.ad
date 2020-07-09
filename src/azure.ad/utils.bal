
// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

function parseError(json errorJsonPayload) returns AdClientError {
    json|error errorJsonOrError = errorJsonPayload.'error;

    if (errorJsonOrError is error) {
        AdClientError adClientError = error(AD_CLIENT_ERROR, message = "unable to parse json error payload: " + errorJsonPayload.toJsonString());
        return adClientError;
    }

    json errorJson = <json>errorJsonOrError;
    json|error codeJsonOrError = errorJson.code;
    if (codeJsonOrError is error) {
        AdClientError adClientError = error(AD_CLIENT_ERROR, message = "unable to find error code: " + errorJsonPayload.toJsonString());
        return adClientError;
    }
    json codeJson  = <json>codeJsonOrError;

    json|error messageJsonOrError = errorJson.message;
    if (messageJsonOrError is error) {
        AdClientError adClientError = error(AD_CLIENT_ERROR, message = "unable to find error message: " + errorJsonPayload.toJsonString());
        return adClientError;
    }
    json messageJson = <json>messageJsonOrError;

    map<anydata> details = {};
    json|error detailsJsonOrError = errorJson.innerError;
    if (detailsJsonOrError is json) {
        map<anydata>|error detailsMapOrError = map<anydata>.constructFrom(detailsJsonOrError);
        if (detailsMapOrError is map<anydata>) {
            details = detailsMapOrError;
        }
    }
    
    AdClientError generalError = error(codeJson.toString(), message = messageJson.toString(), details = details);
    return generalError;
}
