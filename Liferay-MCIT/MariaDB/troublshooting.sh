yum install libssl*                                                                                                                                                                          
yum install libpmem                                                                                                                                                                          
                                                                                                                                                                       
yum install libcry*                                                                                                                                                                          
                                                                                                                                                                         
yum install libboost*                                                                                                                                                                        
yum install socat                                                                                                                                                                            
                                                                                                                   
                                                                                                           
yum install  /home/AAbdelkader_c/boost-program-options-1.66.0-13.el8.x86_64.rpm                                                                                                              
                                                                                                                    
yum install perl                                                                                                                                                                             
                                                                                                                      
vi /etc/yum.repos.d/mariadb.repo                                                                                                                                                             
yum --disablerepo="*" --enablerepo=mariadb-main  install mariadb-server