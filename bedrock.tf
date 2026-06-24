resource "aws_bedrockagent_agent" "music_agent" {
  agent_name                  = "${var.project_name}-music-agent"
  foundation_model            = "amazon.nova-2-lite-v1:0"
  agent_resource_role_arn     = aws_iam_role.bedrock_agent_role.arn
  idle_session_ttl_in_seconds = 600

  instruction = <<EOF
    You are the playlist generation agent for m3-music.

    Rules:
    - Always call querySongs before recommending music.
    - Only return songs present in the querySongs response.
    - Never invent song titles, song IDs, artists, URLs, genres, or metadata.
    - If querySongs returns no matches, return {"playlist": [], "message": "No matching songs found"}.
    - Prefer exact mood and genre matches first, then nearby matches from the returned tool data.
    - Keep reasons short and based only on returned metadata.

    Output strict JSON:
      {
        "playlist": [
          { "songId": "", "reason": "" }
        ]
      }
  EOF
}

# resource "aws_bedrockagent_agent_action_group" "music_actions" {
#   agent_id          = aws_bedrockagent_agent.music_agent.id
#   agent_version     = "DRAFT"
#   action_group_name = "MusicActions"

#   action_group_executor {
#     lambda = aws_lambda_function.query_songs.arn
#   }

#   api_schema {
#     payload = jsonencode({
#       openapi = "3.0.1"
#       info = {
#         title   = "Music Query API"
#         version = "1.0"
#       }
#       paths = {
#         "/querySongs" = {
#           post = {
#             operationId = "querySongs"
#             description = "Query indexed songs by mood, genre, and optional upload time window. Returns only songs that exist in the catalog."
#             requestBody = {
#               required = true
#               content = {
#                 "application/json" = {
#                   schema = {
#                     type = "object"
#                     properties = {
#                       mood = {
#                         type        = "string"
#                         description = "Requested listener mood."
#                       }
#                       genre = {
#                         type        = "string"
#                         description = "Requested music genre."
#                       }
#                       uploadedAfter = {
#                         type        = "string"
#                         description = "Optional ISO-8601 lower bound for uploadedAt."
#                       }
#                       limit = {
#                         type        = "integer"
#                         minimum     = 1
#                         maximum     = 25
#                         description = "Maximum number of songs to return."
#                       }
#                     }
#                   }
#                 }
#               }
#             }
#             responses = {
#               "200" = {
#                 description = "Existing song list from the catalog."
#                 content = {
#                   "application/json" = {
#                     schema = {
#                       type = "object"
#                       properties = {
#                         songs = {
#                           type = "array"
#                           items = {
#                             type = "object"
#                             properties = {
#                               songId     = { type = "string" }
#                               title      = { type = "string" }
#                               artist     = { type = "string" }
#                               mood       = { type = "string" }
#                               genre      = { type = "string" }
#                               uploadedAt = { type = "string" }
#                             }
#                           }
#                         }
#                       }
#                     }
#                   }
#                 }
#               }
#             }
#           }
#         }
#       }
#     })
#   }

#   depends_on = [aws_lambda_permission.allow_bedrock_query]
# }
