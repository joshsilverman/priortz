# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready -> 
    h = $('div.axis').height()
    w = $('div.axis').width()
    
    #position divs
    $ -> $('.left_col div.task').each ->
        offsetImportance = $(this).attr('importance')/100*(w-20)
        offsetUrgency = h - $(this).attr('urgency')/100*(h-12)
        $(this).css('left', offsetImportance)
        $(this).css('top', offsetUrgency)
        
    #make draggable
    $(".left_col div.task").draggable
        containment: 'parent'
        stop: (e, ui) ->
            importance = Math.round ui.offset.left/(w-20)*100
            urgency = Math.round (h - ui.offset.top)/(h-20)*100
             
            #post new status
            $.ajax(
                "/tasks/#{ui.helper['0'].id}"
                data:
                    task:
                        importance: importance
                        urgency: urgency
                type:'put'
            )
            
            $.get(
                "/tasks/list_ordered"
                urgency: urgency
                (r) -> $('.right_col').html r
            )
            
    $('.right_col div.task input').each (id, elmnt) ->
        $(elmnt).bind 'click', ->
            if elmnt.checked
                $(".left_col ##{elmnt.id}").hide()
            else 
                $(".left_col ##{elmnt.id}").show()
                
#            $.ajax(
#                "/tasks/#{ui.helper['0'].id}"
#                data:
#                    task:
#                        complete:elmnt.checked
#                type:'put'
#            )