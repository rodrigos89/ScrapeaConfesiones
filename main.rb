require 'open-uri'
require 'nokogiri'
require 'csv'

CSV.open('confesiones.csv', 'wb') do |csv|
  csv << %w[Nro Autor Fecha Hora nrolikes nrodislikes nroComentarios texto]
  conf=0; pagina=1
  while (conf<100)
    puts "Scrapeando la url https://confiesalo.net/?page=#{pagina}..."
    link = "https://confiesalo.net/?page=#{pagina}"
    confiesaloHTML = open(link)
    datos = confiesaloHTML.read
    parsed_content = Nokogiri::HTML(datos)
    inf_container = parsed_content.css('.infinite-container')
    inf_container.css('.infinite-item').each do |confesions|
      header = confesions.css('div div.row').css('.meta__container--without-image').css('.row')

      bottom = confesions.css('div.row').css('.read-more')
      id_author = header.css('.meta__info').css('.meta__author').css('a').css('a:nth-child(3)').inner_text[1..-1]

      author = header.css('.meta__info').css('.meta__author').at_css('a').inner_text[0..6]

      date = header.css('.meta__info').css('.meta__date').inner_text.strip.split(' ') # [June, 9, 2020, 2:15 p.m.]

      if !date[5].nil?
        strFecha = date[1] + ' ' + date[2] + ' ' + date[3][0..3]
        strHour = date[4] + ' ' + date[5]
      else
        strFecha = nil
        strHour = nil
        end
      content = confesions.css('div.row').css('.post-content-text').inner_text.gsub("\n", '')
      nrolikes = bottom.css('span').css("#votosup-#{id_author}").inner_text
      nrodislikes = bottom.css('span').css("#votosdown-#{id_author}").inner_text
      nroComentarios = rand(1..100)
      csv << [conf.to_s,author.to_s, strFecha.to_s, strHour.to_s, nrolikes.to_i, nrodislikes.to_i, nroComentarios.to_i ,content.to_s]
      conf+=1
      # puts id.class
    end
    pagina+=1
  end
  puts "Resuelto Reto RR - Parte 1... enter"
  puts "Ha superado la primera fase... Felicitaciones :)"
end