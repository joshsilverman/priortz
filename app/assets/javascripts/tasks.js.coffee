# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready -> 
    
    #position divs (and adjust visibility)
    positionDivs = ->
        h = $('div.axis').height()
        w = $('div.axis').width()
        $ -> $('.left_col div.task').each ->
            offsetImportance = $(this).attr('importance')/100*(w-20)
            offsetUrgency = h - $(this).attr('urgency')/100*(h-12)
            $(this).css('left', offsetImportance)
            $(this).css('top', offsetUrgency)
            
            #visibility
            if $(this).attr('complete')
                console.log "yo"
                $(this).hide()
        
    #make draggable
    makeDraggable = ->
        h = $('div.axis').height()
        w = $('div.axis').width()
        
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
                    (r) -> 
                        $('.right_col').html r
                        addListeners()
                )
            
    #add listeners
    addListeners = ->
        $('.left_col div.remove').each (id, elmnt) ->
            $(elmnt).bind 'click', ->
                $.ajax(
                    "/tasks/#{elmnt.id}"
                    type:'delete'
                )
    
        $('.right_col div.task input[type=checkbox]').each (id, elmnt) ->
            $(elmnt).bind 'click', ->
                if elmnt.checked
                    $(".left_col ##{elmnt.id}").hide()
                else 
                    $(".left_col ##{elmnt.id}").show()
                    
                #update complete state
                $.ajax(
                    "/tasks/#{elmnt.id}"
                    data:
                        task:
                            complete: elmnt.checked
                    type:'put'
                )
                    
        #new task submit listener
        $('.right_col div.task input[type=text]').keypress (e, elmnt) ->
            if (e.which == 13)
               $.post(
                    "/tasks"
                    task:
                        'name':$(this)[0].value
                        importance:50
                        urgency:50
                    (r) -> 
                        $('.axis').html r
                        positionDivs()
                        makeDraggable()
                        addListeners()
                        $(this)[0].value = ''
               )
              
    #load
    load = ->
        positionDivs()
        addListeners()
        makeDraggable()
        $(window).resize ->
            positionDivs()
    load()
              
#            $.ajax(
#                "/tasks/#{ui.helper['0'].id}"
#                data:
#                    task:
#                        complete:elmnt.checked
#                type:'put'
#            )