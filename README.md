# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  2.7.6

* Rails version
  6.0.6

* System dependencies  
  Ngrok  
  Node version: 14  

* Project Setup
  In Project directory, run the following commands for setup  
  - bundle install  
  - yarn install  
  - bundle exec rake assets:precompile  

* How to Run the Project  
  In Project directory, use the following commands to run  

  - ngrok http 3000  
  - rails s -p 3000  
  - visit http://localhost:3000/  
  - Go to https://www.paved.com/tools/email_headers  
  - Enter Email Address in first input  
  - Enter Post URL in second input(check next step for getting the URL)  
  - Copy the url from Ngrok and update the below url accordingly  
    (don't forget to add the last part "/email_validator/validate"),
    it should be something like this  
    https://e1b0-182-185-218-167.ngrok-free.app/email_validator/validate  
  - After hitting Send Headers button, server should receive hit from paved.com  

* Files in considereation:
  - EmailAuthenticationService  
  - EmailValidatorController  
  - home/index.html.erb  
