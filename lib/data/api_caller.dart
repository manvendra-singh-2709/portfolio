import 'dart:developer';

import 'package:port/models/project.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/blog.dart';
import '../models/message.dart';

class ApiCaller {
  static final SupabaseClient supabase = Supabase.instance.client;

  static Stream<List<Project>> getProjects() {
    try {
      return supabase
          .from('Projects')
          .stream(primaryKey: ['id']) 
          .map((data) {
            final List<Project> projects = data.map((json) {
              return Project(
                id: json['id'],
                name: json['title'] ?? 'No Title',
                description: json['desc'] ?? 'No Description',
                icon: Project.getIconData(json['icon']),
              );
            }).toList();

            projects.sort((a, b) => a.id.compareTo(b.id));
            return projects;
          });
    } catch (e) {
      log('Error fetching projects: $e');
      return Stream.empty();
    }
  }

  static Future<bool> sendMessage(Message message) async {
    try {
      await supabase.from('Messages').insert({
        'name': message.name,
        'email': message.email,
        'message': message.message,
        'time': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      log("Supabase Error: $e");
      return false;
    }
  }

  static Future<List<Blog>> getBlogs() async {
    try {
      final List<Map<String, dynamic>> data = await supabase
          .from('Blogs')
          .select()
          .order('time', ascending: false);

      return data.map((json) {
        return Blog(
          id: json['id'],
          title: json['title'] ?? 'No Title',
          time: DateTime.parse(json['time']),
          content: json['content'] ?? '',
        );
      }).toList();
    } catch (e) {
      log('Error fetching blogs: $e');
      return [];
    }
  }

  static Future<bool> addBlog(String title, String content) async {
    try {
      await supabase.from('Blogs').insert({
        'title': title,
        'content': content,
        'time': DateTime.now().toIso8601String(),
      });

      log('Blog added successfully!');
      return true;
    } catch (e) {
      log('Error adding blog: $e');
      return false;
    }
  }
}
