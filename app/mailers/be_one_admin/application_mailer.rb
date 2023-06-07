module BeOneAdmin
  class ApplicationMailer < ActionMailer::Base
    default from: (Rails.application.secrets.fetch(:smtp,{}).fetch(:admin_from, nil) || 'admin@example.com')
    layout 'mailer'

    protected

    def send_mail( template, to_email, attachments = {}, from_email = false )
      mail_options = {
        to: to_email,
        subject: template.subject
      }
      mail_options.merge!(from: from_email) if from_email.present?

      attachments.each{ |k,v| self.attachments[k] = v } if attachments.kind_of? Hash
      mail(mail_options) do |format|
        format.html {render html: template.text.html_safe}
      end
    end

    def safe_action( code, &block )
      begin
        operation = BeOneAdmin::EmailOperation::Find.new( code: code )
        fail Operation::Error.new( operation.errors ) unless template = operation.process
        template = template.dup
        email, attachmets = *yield(template)
        Journal.success( log_code: :mail, args: {emails: email}, session_id: code, description: template.subject , file:{content: template.text ,type:"raw"} )
        send_mail template, email.wrap.join(","), attachmets
      rescue => e
        Journal.exception( log_code: :mail, args: {emails: email}, session_id: code, description: e.message , file:{content: e.backtrace.join("\n"),type:"raw"} )
      end
    end

  end
end
