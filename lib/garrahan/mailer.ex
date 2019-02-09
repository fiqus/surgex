defmodule Garrahan.Mailer do
  use Bamboo.Mailer, otp_app: :garrahan
end

defmodule Garrahan.Email do
  import Bamboo.Email

  def set_password_email(user, activation_url) when is_binary(activation_url) do
    name = "#{user.first_name} #{user.last_name}"

    new_email()
    |> to({name, user.email})
    |> from({"Garrahan app", "info+garrahan@fiqus.com"})
    |> put_header("Reply-To", "no-reply@fiqus.com")
    |> subject("Hola #{name}, por favor activa tu cuenta")
    |> html_body(
      "<strong>Bienvenido #{name}!</strong><br/>Por favor clickeá aquí para setear tu password y activar tu cuenta:<br/>#{
        activation_url
      }"
    )
    |> text_body(
      "Bienvenido #{name}!\nPor favor clickeá aquí para setear tu password y activar tu cuenta:\n#{
        activation_url
      }"
    )
  end
end
