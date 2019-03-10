defmodule Garrahan.Mailer do
  use Bamboo.Mailer, otp_app: :garrahan
end

defmodule Garrahan.Email do
  import Bamboo.Email

  def set_password_email(surgeon, activation_url) when is_binary(activation_url) do
    name = "#{surgeon.first_name} #{surgeon.last_name}"

    new_email()
    |> to({name, surgeon.email})
    |> from({"Garrahan App", "info+garrahan@fiqus.com"})
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

  def set_recover_email(surgeon, recover_url) when is_binary(recover_url) do
    name = "#{surgeon.first_name} #{surgeon.last_name}"

    new_email()
    |> to({name, surgeon.email})
    |> from({"Garrahan App", "info+garrahan@fiqus.com"})
    |> put_header("Reply-To", "no-reply@fiqus.com")
    |> subject("Recuperar acceso a cuenta")
    |> html_body(
      "<strong>Hola #{name}!</strong><br/>Por favor clickee aquí para recuperar su cuenta:<br/>#{
        recover_url
      }"
    )
    |> text_body(
      "Hola #{name}!\nPor favor clickee aquí para recuperar su cuenta:\n#{recover_url}"
    )
  end
end
