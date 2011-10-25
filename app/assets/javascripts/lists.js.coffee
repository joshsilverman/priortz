$(document).ready -> 
   
    #props
    nextHighestZ = 1
   
    #calibrate graph dimensions
    h = w = w_offset = h_offset = 0
    calibrateGraph = ->
        h_offset = $('.axis').offset().top
        w_offset = $('.axis').offset().left
        h = $('div.axis').height()
        w = $('div.axis').width()
    
    #position divs (and adjust visibility)
    positionDivs = ->
        calibrateGraph()
        $ -> $('.left_col div.task').each ->
            offsetUrgency = $(this).attr('urgency')/100*w
            offsetImportance = h - $(this).attr('importance')/100*(h)
            $(this).css('left', offsetUrgency)
            $(this).css('top', offsetImportance)
            
            #visibility
            if $(this).attr('complete') == "true"
                $(this).hide()
        
    #make draggable
    makeDraggable = ->
        $(".left_col div.task").draggable
            containment: 'parent'
            stop: (e, ui) ->
                calibrateGraph()
                urgency = Math.round (ui.offset.left - w_offset)/w*100
                importance = Math.round (h - ui.offset.top + h_offset)/(h)*100

                #post new status
                id = $(ui.helper['0']).attr('task_id')
                $.ajax(
                    "/tasks/#{$(ui.helper['0']).attr('task_id')}"
                    data:
                        task:
                            urgency: urgency
                            importance: importance
                    type:'put'

                    complete: (r) -> 
                        $.get(
                            "/tasks/list_ordered"
                            (r) -> 
                                $('.right_col').html r
                                addListeners()
                        )
                        
                        tasks = $(".task[task_id=#{id}]")
                        tasks.attr({urgency:urgency, importance:importance})
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
                        list_id:$('.right_col').attr('list_id')
                        urgency:50
                        importance:50
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
        $.loading(
            onAjax:true, 
            text: 'Loading...'
        )
    load()