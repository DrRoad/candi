function(input, output, session) {
    # Reactive Conductors -----------------
    ids <- reactive({
        x <- map(kID_FIELDS, function(x) x=input[[x]])
        x$timestamp <- lubridate::now()
        x %<>% as.data.frame()
    })

    bboxCoordinates <- reactive({
        data.frame(input$bbox_brush[c("xmin", "xmax", "ymin", "ymax")]) %||% data.frame()
    })

    classificationDF <- reactive({
        df <- ids()
        df$Pathologies <- toString(input$pathologies)
        df
    })

    segmentationDF <- reactive({
        df <- ids()
        coords <- bboxCoordinates()
        bind_cols(df, coords)
    })

    clinicalNoteDF <- reactive({
        df <- ids()
        df$ClinicalNote <- input$note
        df
    })


    # ---- Observers ----
    observeEvent(
        eventExpr = input$submit_classification,
        handlerExpr = {
            save_annotation(classificationDF(), ann_type = "classification")
        }
    )

    observeEvent(input$submit_cardiomegaly, save_segmentation(segmentationDF(), "cardiomegaly"))
    observeEvent(input$submit_emphysema, save_segmentation(segmentationDF(), "emphysema"))
    observeEvent(input$submit_effusion, save_segmentation(segmentationDF(), "effusion"))

    observeEvent(input$submit_note,
                 save_annotation(clinicalNoteDF(), "clinical_note"))


    # Conditionally hide/disable segmentation submission
    observe(shinyjs::toggle("segmentation", anim=TRUE, condition=!is.null(input$pathologies)))
    observe(shinyjs::toggleState("submit_cardiomegaly",
                                 condition = nrow(bboxCoordinates()) > 0 && "cardiomegaly" %in% input$pathologies))
    observe(shinyjs::toggleState("submit_emphysema",
                                 condition = nrow(bboxCoordinates()) > 0 && "emphysema" %in% input$pathologies)    )
    observe(shinyjs::toggleState("submit_effusion",
                                 condition = nrow(bboxCoordinates()) > 0 && "effusion" %in% input$pathologies))

    observeEvent(
        eventExpr = input$openiBtn,
        handlerExpr = {
            updateTextInput(session, inputId = "image_url", value = iu_db_lut[[input$img_id]])
        }
    )

    # ---- Outputs ----
    output$radiographImage <- renderImage({
        req(input$image_url)
        # Fetch the requested image, save to temp file, push to client, delete temp file
        img <- EBImage::readImage(input$image_url) %>%
            EBImage::resize(w=299,h=299)
        temp_fp <- tempfile(fileext = ".jpg")
        EBImage::writeImage(img, temp_fp)

        list(src = temp_fp, filetype="image/jpeg")
    }, deleteFile = TRUE)

    # Brush Coordinates
    output$coordinatesTable <- renderTable({bboxCoordinates()})

    # Downloads
    output$downloadClassification <- handle_annotation_download("classification", f_load = load_annotation)
    output$downloadSegmentation <- handle_annotation_download("segmentation", f_load = load_annotation)
    output$downloadClinicalNote <- handle_annotation_download("clinical_note", f_load = load_annotation)

    # Image/Annotation Sources
    output$annotationURL <- renderText(gsURL)
}
