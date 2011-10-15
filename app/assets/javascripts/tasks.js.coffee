# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready -> 
    h = $(document).height()
    w = $(document).width()
    
    #position divs
    $ -> $('div').each -> 
        offsetImportance = w - $(this).attr('importance')/100*(w-20)
        offsetUrgency = h - $(this).attr('urgency')/100*(h-12)
        $(this).css('left', offsetImportance)
        $(this).css('top', offsetUrgency)
        
    #make draggable
    $("div").draggable
        stop: (e, ui) ->
            importance = Math.round (w - ui.offset.left)/(w-20)*100
            urgency = Math.round (h - ui.offset.top)/(h-20)*100
            console.log ui.helper['0'].id
            console.log importance
            console.log urgency
             
            #post new status
            $.ajax(
                "/tasks/#{ui.helper['0'].id}"
                urgency: urgency
                data:
                    task:
                        importance: importance
                        urgency: urgency
                type:'put'
#                -> alert('done')
            )