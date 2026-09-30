class ContactMessagesController < ApplicationController
  def create
    @contact_message = ContactMessage.new(contact_message_params)

    if @contact_message.save
      redirect_to contact_path, notice: "Thank you! We'll get back to you soon."
    else
      render "storefront/pages/contact", status: :unprocessable_entity
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :subject, :message)
  end
end