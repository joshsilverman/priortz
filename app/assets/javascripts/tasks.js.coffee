# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready -> 
   
    #props
    nextHighestZ = 1
   
    #calibrate graph dimensions
    h = w = 0
    calibrateGraph = ->
        h = $('div.axis').height()
        w = $('div.axis').width()
    
    #position divs (and adjust visibility)
    positionDivs = ->
        calibrateGraph()
        $ -> $('.left_col div.task').each ->
            offsetImportance = $(this).attr('importance')/100*(w-20)
            offsetUrgency = h - $(this).attr('urgency')/100*(h-12)
            $(this).css('left', offsetImportance)
            $(this).css('top', offsetUrgency)
            
            #visibility
            if $(this).attr('complete') == "true"
                $(this).hide()
        
    #make draggable
    makeDraggable = ->
        $(".left_col div.task").draggable
            containment: 'parent'
            stop: (e, ui) ->
                calibrateGraph()
                importance = Math.round ui.offset.left/(w-20)*100
                urgency = Math.round (h - ui.offset.top)/(h-20)*100

                #post new status
                id = $(ui.helper['0']).attr('task_id')
                $.ajax(
                    "/tasks/#{$(ui.helper['0']).attr('task_id')}"
                    data:
                        task:
                            importance: importance
                            urgency: urgency
                    type:'put'

                    complete: (r) -> 
                        $.get(
                            "/tasks/list_ordered"
                            (r) -> 
                                $('.right_col').html r
                                addListeners()
                        )
                        
                        tasks = $(".task[task_id=#{id}]")
                        tasks.attr({importance:importance, urgency:urgency})
                )
            
    #add listeners
    addListeners = ->
    
        #remove
        $('span.remove').each (id, elmnt) ->
            $(elmnt).unbind 'click'
            $(elmnt).bind 'click', ->
                elmnt = $(elmnt)
                
                $.ajax(
                    "/tasks/#{elmnt.attr('task_id')}"
                    type:'delete'
                    complete: -> 
                      $("div.task[task_id=#{elmnt.attr('task_id')}]").hide()
                )
    
        #complete
        $('div.task input[type=checkbox]').each (id, elmnt) ->
        
            $(elmnt).bind 'click', ->
                if elmnt.checked
                    tasks = $(".task[task_id=#{$(elmnt).attr('task_id')}]")
                    tasks.attr('complete', 'true')
                else
                    tasks = $(".task[task_id=#{$(elmnt).attr('task_id')}]")
                    tasks.attr('complete', 'false')
                    
                #update both checkboxes
                checkboxes = $(".task[task_id=#{$(elmnt).attr('task_id')}] input[type=checkbox]")
                checkboxes.attr('checked', elmnt.checked)
                    
                #update complete state
                $.ajax(
                    "/tasks/#{$(elmnt).attr('task_id')}"
                    data:
                        task:
                            complete: elmnt.checked
                    type:'put'
                )
                    
        #new task submit
        $('.right_col div.task input[type=text]').keypress (e, elmnt) ->
            if (e.which == 13)
               $.post(
                    "/tasks"
                    task:
                        'name':$(this)[0].value
                        importance:50
                        urgency:50
                    (r) ->
                        $('body').html r
                        load()
               )
               
        #highlight task
        $('div.task').each (id, elmnt) ->
            $(elmnt).bind 'mousedown', (e) ->
                id = $(elmnt).attr('task_id')
                $(".task").attr('active', false)
                $(".task[task_id=#{id}]").attr('active', 'true')
                plotted_task = $(".left_col div.task[task_id=#{id}]")
                plotted_task.css('z-index', nextHighestZ++)
                
    #load
    load = ->
        positionDivs()
        addListeners()
        makeDraggable()
        $(window).resize ->
            positionDivs()
    load()