package br.com.valdenor.teafala

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.Typeface
import android.graphics.pdf.PdfDocument
import java.io.ByteArrayOutputStream

internal object CommunicationBoardPdf {
    fun create(title: String, labels: List<String>): ByteArray {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.BLACK
            typeface = Typeface.create(Typeface.SANS_SERIF, Typeface.BOLD)
            textAlign = Paint.Align.CENTER
        }

        val document = PdfDocument()
        return try {
            val page = document.startPage(PdfDocument.PageInfo.Builder(595, 842, 1).create())
            try {
                val canvas = page.canvas
                canvas.drawColor(Color.WHITE)
                drawLabel(canvas, paint, title, 297.5f, 58f, 28f, 523f)

                labels.forEachIndexed { index, label ->
                    val left = if (index == 6) 172f else 36f + index % 2 * 271f
                    val top = 83f + index / 2 * 174f
                    val center = left + 126f
                    paint.style = Paint.Style.STROKE
                    paint.strokeWidth = 2f
                    canvas.drawRoundRect(left, top, left + 252f, top + 156f, 8f, 8f, paint)

                    canvas.save()
                    canvas.translate(center - 40f, top + 17f)
                    drawSymbol(canvas, paint, index)
                    canvas.restore()
                    drawLabel(canvas, paint, label, center, top + 131f, 21f, 224f)
                }
            } finally {
                document.finishPage(page)
            }
            ByteArrayOutputStream().use { output ->
                document.writeTo(output)
                output.toByteArray()
            }
        } finally {
            document.close()
        }
    }

    private fun drawLabel(
        canvas: Canvas,
        paint: Paint,
        text: String,
        x: Float,
        y: Float,
        size: Float,
        maxWidth: Float,
    ) {
        paint.style = Paint.Style.FILL
        paint.textSize = size
        val width = paint.measureText(text)
        if (width > maxWidth) paint.textSize = size * maxWidth / width
        canvas.drawText(text, x, y, paint)
    }

    // Original high-contrast drawings built from simple strokes.
    private fun drawSymbol(canvas: Canvas, paint: Paint, index: Int) {
        paint.strokeWidth = 5f
        paint.strokeCap = Paint.Cap.ROUND
        paint.strokeJoin = Paint.Join.ROUND
        when (index) {
            0 -> stroke(canvas, paint, 11f, 42f, 31f, 62f, 69f, 20f)
            1 -> {
                stroke(canvas, paint, 17f, 17f, 63f, 63f)
                stroke(canvas, paint, 63f, 17f, 17f, 63f)
            }
            2 -> {
                stroke(canvas, paint, 25f, 5f, 55f, 5f, 75f, 25f, 75f, 55f,
                    55f, 75f, 25f, 75f, 5f, 55f, 5f, 25f, 25f, 5f)
                stroke(canvas, paint, 22f, 40f, 58f, 40f)
            }
            3 -> {
                canvas.drawCircle(40f, 40f, 34f, paint)
                canvas.drawArc(28f, 20f, 52f, 44f, 180f, 270f, false, paint)
                stroke(canvas, paint, 40f, 44f, 40f, 49f)
                canvas.drawPoint(40f, 60f, paint)
            }
            4 -> {
                paint.style = Paint.Style.FILL
                canvas.drawRoundRect(20f, 14f, 33f, 66f, 3f, 3f, paint)
                canvas.drawRoundRect(47f, 14f, 60f, 66f, 3f, 3f, paint)
            }
            5 -> {
                canvas.drawRoundRect(12f, 10f, 33f, 42f, 4f, 4f, paint)
                stroke(canvas, paint, 12f, 42f, 70f, 42f, 64f, 55f,
                    51f, 62f, 51f, 73f, 25f, 73f, 25f, 61f, 15f, 54f, 12f, 42f)
            }
            6 -> {
                canvas.drawCircle(40f, 40f, 34f, paint)
                canvas.drawPoint(29f, 32f, paint)
                canvas.drawPoint(51f, 32f, paint)
                canvas.drawArc(26f, 46f, 54f, 68f, 205f, 130f, false, paint)
            }
        }
    }

    private fun stroke(canvas: Canvas, paint: Paint, vararg points: Float) {
        val path = Path().apply {
            moveTo(points[0], points[1])
            for (index in 2 until points.size step 2) lineTo(points[index], points[index + 1])
        }
        canvas.drawPath(path, paint)
    }
}
