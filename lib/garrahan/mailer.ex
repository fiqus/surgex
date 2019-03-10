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
    |> subject("Activar nueva cuenta")
    |> html_body("<strong>¡Hola #{name}!</strong><br/>
      Le damos la bienvenida al servicio de cirugía plástica del hospital de pediatría Garrahan.<br/>
      <br/>
      Por favor ingrese a esta dirección para establecer su contraseña y activar su cuenta:<br/>
      #{activation_url}<br/>
      <br/>
      Si tiene algún inconveniente, contáctese con el administrador.<br/>
      ¡Muchas gracias!
      ")
    |> text_body("¡Hola #{name}!\n
      Le damos la bienvenida al servicio de cirugía plástica del hospital de pediatría Garrahan.\n
      \n
      Por favor ingrese a esta dirección para establecer su contraseña y activar su cuenta:\n
      #{activation_url}\n
      \n
      Si tiene algún inconveniente, contáctese con el administrador.\n
      ¡Muchas gracias!
      ")
  end

  def set_recover_email(surgeon, recover_url) when is_binary(recover_url) do
    name = "#{surgeon.first_name} #{surgeon.last_name}"

    new_email()
    |> to({name, surgeon.email})
    |> from({"Garrahan App", "info+garrahan@fiqus.com"})
    |> put_header("Reply-To", "no-reply@fiqus.com")
    |> subject("Recuperar acceso a cuenta")
    |> html_body("<strong>¡Hola #{name}!</strong><br/>
      Se ha solicitado reestablecer la contraseña de su cuenta.<br/>
      Si usted no inició esta solicitud, simplemente ignore este email.<br/>
      <br/>
      Ingrese a esta dirección para recuperar el acceso a su cuenta:<br/>
      #{recover_url}<br/>
      <br/>
      Si tiene algún inconveniente, contáctese con el administrador.<br/>
      ¡Muchas gracias!
      ")
    |> text_body("¡Hola #{name}!\n
      Se ha solicitado reestablecer la contraseña de su cuenta.\n
      Si usted no inició esta solicitud, simplemente ignore este email.\n
      \n
      Ingrese a esta dirección para recuperar el acceso a su cuenta:\n
      #{recover_url}\n
      \n
      Si tiene algún inconveniente, contáctese con el administrador.\n
      ¡Muchas gracias!
      ")
  end
end
