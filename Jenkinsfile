/* Declarative Jenkins Pipeline
1. Builds docker dockerImage
2. Pushes image to dockerhub
3. Deploys the container image as a stand alone container
4. Executes Redshift pipeline code for execution
5. Adding changes for dry run
*/
pipeline {
    environment {
        AWS_DEFAULT_REGION='ap-south-1'
        configFile ='query_redshift_api.ini'
        rollbackConfigFile  = 'rollback.ini'
        output = 'f'
        // name = 'rs_containerv1'
        /*Parameters to be modified */
        clusterconfigfile='dw_config.ini'
        clusterconfigparm='test_poc_1'
        /*Name of the section and query id to be executed default:ALL */
        sectionName ='ALL'
        rollbackSectionName='DDM_v01'
        query_id ='ALL'
    }

    agent {
        docker {
            alwaysPull true
            image 'onkar406/redshift-container:latest'
            registryCredentialsId 'dockerhub-credentials'
            reuseNode false
        }
    }

    stages {
        stage ('Run Rollforward') {
            steps {
                script {
                    sh '''#!/usr/bin/env bash
                    python3 --version
                    python3 -m pip freeze
                    '''

                    withAWS(credentials: 'terraform-access', region: "${AWS_DEFAULT_REGION}") {
                        sh '''#!/usr/bin/env bash
                        ls -alh ./**
                        cd src
                        python3 python_client_redshift_ephemeral.py rollforward $configFile $sectionName $query_id $output $clusterconfigfile $clusterconfigparm
                        echo "$?"
                        '''
                    }
                }
            }
        }

        stage('Sleep') {
            steps {
                sh '''#!/usr/bin/env bash
                echo 'Sleeping for 30 sec'
                sleep 30
                '''
            }
        }

        stage ('Run Rollback') {
            steps {
                script {
                    withAWS(credentials: 'terraform-access', region: "${AWS_DEFAULT_REGION}") {
                        sh '''#!/usr/bin/env bash
                        cd src
                        python3 python_client_redshift_ephemeral.py rollforward $rollbackConfigFile $rollbackSectionName $query_id $output $clusterconfigfile $clusterconfigparm
                        echo "$?"
                        # find / -type d -iname "output_data"
                        # find / -type d -iname "exec_pointer"
                        tar -cvf archive.tar "${WORKSPACE}"
                        '''
                        archiveArtifacts artifacts: 'src/*.tar', allowEmptyArchive: 'true'
                    }
                }
            }
        }
    }
}