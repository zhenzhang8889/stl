class FeedbackMailer < ActionMailer::Base


  #default to: "messages@surpassthelimit.com"
  default to: "wchangx@gmail.com"
  def feedback(from, name, contents) 
    @name = name
    @contents = contents   
    mail(:from => from, :subject => 'Feedback') do |format|
      format.html
      format.text
    end
  end  
end
