import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_project/controller/event_controller.dart';
import 'package:tcc_project/model/event.dart';
import '../theme/app_colors.dart';

class Events extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EventController>();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.primary(context),
        iconTheme: IconThemeData(color: AppColors.white(context)),
        title: Text(
          "Eventos do Parque",
          style: TextStyle(color: AppColors.white(context), fontSize: 18),
        ),
      ),
      body: StreamBuilder<List<Event>>(
        stream: context.read<EventController>().service.getEvents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary(context)),
            );
          }

          final events = snapshot.data!;
          events.sort((a, b) => b.data!.compareTo(a.data!));
          controller.loadEvents(snapshot.data!);

          if (controller.allEvents.isEmpty) {
            return Center(
              child: Text(
                "Nenhum evento disponível.",
                style: TextStyle(color: AppColors.textPrimary(context)),
              ),
            );
          }

          return PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: controller.allEvents.length,
            itemBuilder: (context, index) {
              final event = controller.allEvents[index];
              return EventCard(event: event);
            },
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final isPastEvent = event.isPast;
    final cardHeight = MediaQuery.of(context).size.height * 0.75;
    final cardWidth = MediaQuery.of(context).size.width * 0.9;

    return Center(
      child: Container(
        height: cardHeight,
        width: cardWidth,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'event-${event.id}',
                child: Image.network(event.imageUrl, fit: BoxFit.cover),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.black(context).withOpacity(0.65),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.titulo,
                      style: TextStyle(
                        color: AppColors.white(context),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: AppColors.black(context).withOpacity(0.4),
                            offset: Offset(1, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      event.data != null
                          ? "${event.data!.day.toString().padLeft(2, '0')}/${event.data!.month.toString().padLeft(2, '0')}/${event.data!.year}\n${event.data!.hour.toString().padLeft(2, '0')}:${event.data!.minute.toString().padLeft(2, '0')}"
                          : 'Data não informada',
                      style: TextStyle(
                        color: AppColors.white(context).withOpacity(0.85),
                        fontSize: 18,
                        shadows: [
                          Shadow(
                            color: AppColors.black(context).withOpacity(0.4),
                            offset: Offset(1, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    if (!isPastEvent)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EventDetailScreen(
                                imageUrl: event.imageUrl,
                                tag: 'event-${event.id}',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryStrong(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Ver mais",
                          style: TextStyle(
                            color: AppColors.white(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (isPastEvent)
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "Evento já ocorreu",
                          style: TextStyle(
                            color: AppColors.white(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String tag;

  EventDetailScreen({required this.imageUrl, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: tag,
              child: InteractiveViewer(
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.black(context).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8),
                child: Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
