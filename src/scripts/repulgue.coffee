# Comandos de hubot para armar el pedido de empanadas
#
# quiero de <sabor>[,<sabor>...] - registra tus gustos de empanadas

TIME_TO_CHOOSE      = '0 0 11 * * fri'
TIME_TO_ORDER       = '0 0 12 * * fri'
ORDERER_ID          = '1'
PREFERENCE_QUESTION = 'Hoy hay empanadas! De que queres las tuyas?'
ORDER_REMINDER      = 'Es hora de hacer el pedido'
ROGER_PHRASE        = 'Entendido'


cronJob = require('cron').CronJob

module.exports = (bot) ->

    save = (preferences, response) ->
        response.send "Queres #{preferences.length} empanadas: #{preferences}"
        # TODO Guardar preferencia (y que si come) en Redis

    bot.respond /quiero empanadas de ([\w\s]+(, [\w\s]+)*)$/i, (response) ->
        preferences = response.match[2].split ', '
        save preferences, response

    # TODO Version sin "quiero " cuando estamos preguntando
    bot.respond /quiero lo de siempre$/i, (response) ->
        # TODO Cargar preferencias de redis, falla si no tiene
        # TODO Guardar que si come
        # save preferences, response

    cronJob TIME_TO_CHOOSE, =>
        # TODO Enviar a todos los usuarios (salvo que ya le hayan dado preferencia)
        bot.send bot.userForId('1'), PREFERENCE_QUESTION
        # TODO Setear el estado e iniciar timeout para reiniciarlo

    bot.respond /(quiero )?(empanadas )?de ([\w\s]+(, [\w\s]+)*)$/i, (response) ->
        # TODO Solo si el estado es "le pregunte recien"
        preferences = response.match[4].split ', '
        save preferences, response

    # TODO Evento para hacer el pedido
    cronJob TIME_TO_ORDER, =>
        bot.send bot.userForId(ORDERER_ID), ORDER_REMINDER

    bot.respond /dame el pedido de empanadas para ([\d]+)$/i, (response)
        diners = response.match[1]
        bot.send "Pedido para #{diners}"
        # TODO Calcular pedido y enviarlo
        # Guardar que nadie come (porque empieza una nueva semana)

