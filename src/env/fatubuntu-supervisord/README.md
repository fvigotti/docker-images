# fvigotti/env-fatubuntu-supervisord 
* based on fvigotti/env-fatubuntu-bashsupervisor image

---   
the reason why supervisord is based on bashsupervisor is that i've not yet  
found a way to move supervisord to pid 1 or, correctly handle signal forwarding to supervisord,  
also a back structure for app initialization is required and fvigotti/env-fatubuntu-bashsupervisor image  
provide that already  
  

